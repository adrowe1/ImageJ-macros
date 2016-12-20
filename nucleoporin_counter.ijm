// preliminary things to clean up 

analyzed=getTitle();
location=getInfo("image.directory");

run("Set Measurements...", "area mean modal min centroid perimeter median display redirect=None decimal=3");

// clean out ROI manager to prevent confusion
if (roiManager("count")>0) {
	tmparr=newArray(roiManager("count"));
	for(i=0;i<roiManager("count");i++) tmparr[i]=i;
	roiManager("Show None");
	roiManager("Select", tmparr);
	roiManager("Delete");
}

run("Clear Results");


// add the hand chosen ROI to the manager and create a subROI simultaneously
roiManager("Add");
roiManager("Select", 0);
roiManager("Rename", "nuclear-outline");
run("Measure");
roiManager("Select", 0);
//run("Scale... ", "x=.7 y=.7 centered");
//roiManager("Add");
//roiManager("Select", 1);
//roiManager("Rename", "nucleus-middle half");
run("Select None");


// duplicate image for later
run("Duplicate...", "title=dup");
selectWindow("dup");
// select ROI for nuclear area
roiManager("Select", 0);
// invert the selection
run("Make Inverse");
// delete everything outside the relevant area
run("Clear", "slice");
// remove selection
run("Select None");
// smooth image once
run("Smooth");
// remove background
run("Subtract Background...", "rolling=30");
// smooth again
run("Smooth");
// find all maxima, hopefully correlating with all NUPs
run("Find Maxima...", "noise=10 output=[Maxima Within Tolerance] exclude");

run("Merge Channels...", "c1=[dup Maxima] c2=dup c5=[" + analyzed + "] create keep ignore");


selectWindow("dup Maxima");
run("Analyze Particles...", "size=0.00-0.02 circularity=0.00-1.00 show=[Overlay Masks] display exclude include add");

roiManager("Show All without labels");
roiManager("Save", location + analyzed + ".zip");

selectWindow("Composite");
run("Compressed TIFF ...", "save=[" + location + analyzed + "RESULTS.tif] imageiosaveas.codecname=tiff imageiosaveas.filename=[" + location + analyzed + "RESULTS.tif]");

saveAs("Results", location + analyzed + "SUM.tsv");
run("Clear Results");

selectWindow("dup Maxima");
close();

selectWindow("dup");
close();

selectWindow("Composite");
roiManager("Show All without labels");


// clean out ROI manager to prevent confusion
if (roiManager("count")>0) {
	tmparr=newArray(roiManager("count"));
	for(i=0;i<roiManager("count");i++) tmparr[i]=i;
	roiManager("Show None");
	roiManager("Select", tmparr);
	roiManager("Delete");
}
