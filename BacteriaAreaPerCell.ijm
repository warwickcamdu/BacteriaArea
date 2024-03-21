run("OMERO Extensions");

//Enter details for connection to OMERO and select Macro to run on Dataset
#@ String (label = "username", value = "public") user
#@ String (label = "password", style="password", value = "public") pass
#@ String (label = "server", value = "camdu.warwick.ac.uk") host
#@ Integer (label = "port", value = 4064) port
#@ Integer (label = "Dataset ID", value = 10000) dataset_id
//#@ File (label = "Macro", style="file") input

//Connect to server and apply macro to each image in dataset
connected = Ext.connectToOMERO(host,port,user,pass);
table_name="BacterialAreaPerCell.csv"
if (connected=="true"){
imageList = Ext.list("images", "dataset", dataset_id);
image=split(imageList, ",");
print(dataset_id);
bactArea=newArray(image.length);
n_nuclei=newArray(image.length);
bact_area_per_cell=newArray(image.length);
for (i = 0; i < image.length; i++) {
	print("start download");
	Ext.getImage(image[i]);
	print(image[i]);
	title=getTitle();
	n_nuclei[i]=countNuclei(image[i],title);
	bactArea[i]=measureBacteria(image[i],title);
	bact_area_per_cell[i]=bactArea[i]/n_nuclei[i];
	print(bact_area_per_cell[i]);
	roiManager("reset");
}
Array.show("Bacterial Area Per Cell", image, n_nuclei, bactArea, bact_area_per_cell);
csv_file = getDir("temp") + table_name;
selectWindow("Bacterial Area Per Cell");
saveAs("Results", csv_file);
file_id = Ext.addFile("Dataset",dataset_id, csv_file);
deleted=File.delete(csv_file);
Ext.disconnect();
print("Finished");
}

function measureBacteria(om_im_id,title){
		Stack.setDisplayMode("color");
Stack.setPosition(1, 1, 1);
Stack.getDimensions(width, height, channels, slices, frames);
selectWindow(title);
max_std=stdCalc(2,slices,1);
if (max_std > 40) {
Stack.getPosition(ch, slice, fr);
run("Duplicate...", "title=stdSlice");
selectWindow("stdSlice");
setAutoThreshold("Huang dark no-reset");
run("Analyze Particles...", "size=1-Infinity circularity=0-1.00 exclude summarize add");
selectWindow(title);
Stack.setPosition(ch, slice, fr);
nrois=roiManager("count");
for (i = 0; i < nrois; i++) {
	roiManager("Select", i);
	Roi.setPosition(2,slice,1);
	roiManager("Add");
}
roiManager("Select", Array.getSequence(nrois));
roiManager("Delete");
selectWindow("stdSlice");
run("Close");
Ext.saveROIs(om_im_id, "");
roiManager("reset");
run("Select None");
selectWindow("Summary");
bact_area=Table.get("Total Area", 0);
run("Close");
} else {
bact_area = 0;
}
selectWindow(title);
run("Close");
return bact_area;
}

function stdCalc(channel,slices,frame){
//Caluclate standard deviation of plane
    max_std = 0;
    for (z = 1; z <= slices; z++) {
    Stack.setPosition(channel,z,frame);
    getStatistics(area, mean, min, max, std);
        if (std > max_std){
            max_std = std;
            slice = z;
        }
    }
    Stack.setPosition(channel,slice,frame);
	return max_std;
}

function countNuclei(om_im_id,title){
	Stack.setDisplayMode("color");
Stack.setPosition(1, 1, 1);
Stack.getDimensions(width, height, channels, slices, frames);

stdCalc(1,slices,1);
Stack.getPosition(ch, slice, fr);
run("Duplicate...", "title=stdSlice");
selectWindow("stdSlice");
setAutoThreshold("Huang dark no-reset");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Watershed");
run("Analyze Particles...", "size=60-Infinity circularity=0.30-1.00 exclude add");
selectWindow(title);
Stack.setPosition(ch, slice, fr);
number_of_nuclei=roiManager("count");
for (i = 0; i < number_of_nuclei; i++) {
	roiManager("Select", i);
	Roi.setPosition(1,slice,1);
	roiManager("Add");
}
roiManager("Select", Array.getSequence(number_of_nuclei));
roiManager("Delete");
selectWindow("stdSlice");
run("Close");
Ext.saveROIs(om_im_id, "");
roiManager("reset");
run("Select None");
return number_of_nuclei;
}