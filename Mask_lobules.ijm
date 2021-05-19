do{
/** init file**/


c2= File.openDialog("blue Channel");
outdir= getDirectory("Outdir");
path= File.getParent(c2);
filename= File.getNameWithoutExtension(c2);
idx = indexOf(filename, "_");
strA = split(substring(filename, idx));
fName = split(filename,strA[0]); 
mskFile=outdir+fName[0];

open(c2);
blue=getTitle();

selectWindow(blue);
run("Split Channels");
close(blue+" (red)");
close(blue+" (green)");

/**set Rois**/
setTool("polygon");
waitForUser("Select Lobule Boundaries");
Roi.setName("Lobule")
roiManager("add");
Roi.getCoordinates(LPx, LPy);

setTool("point");
waitForUser("Set Midpoint");
Roi.setName("Midpoint")
roiManager("add");
Roi.getCoordinates(MPx, MPy);

xval=Array.concat(MPx,LPx);
yval=Array.concat(MPy,LPy);

Table.create("coords");
Table.setColumn("x", xval);
Table.setColumn("y", yval);
saveAs("Results", mskFile+"_coords.csv");
roiManager("deselect");
roiManager("Save", mskFile+".zip");

/** generating Mask
roiManager("Select", 0)
run("Create Mask");
msk = getTitle();
saveAs("PNG", mskFile+"_msk.png");
/** mask Image with lobule mask

imageCalculator("AND create", blue+" (blue)",msk);
masked = getTitle();**/

/** calc background and smear correction**/
selectImage(blue+" (blue)");
img=getTitle();
run("Duplicate...", "title=blur");
run("Gaussian Blur...", "sigma=20");

blur= getTitle();
imageCalculator("Subtract create", img,blur);
bg_cor = getTitle();
saveAs("Tiff", mskFile+".tif");

close("*");

roiManager("delete");

next=getBoolean("next Image?");


} while (next==1);



