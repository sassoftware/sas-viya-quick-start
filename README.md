# SAS Viya Quick Start Videos and Supporting Files

## Overview

[The SAS Viya Quick Start video series](https://video.sas.com/category/videos/sas-viya-quick-start) provides tutorials for many of the SAS Viya applications. The videos are designed to allow users to follow along in the software to enhance their learning experience. This repository provides the files referenced in the videos so that you can configure your environment to follow along.  

### Quick Start Video Series

The following videos are included in the Quick Start series:
- [SAS Viya and the Analytics Life Cycle](https://video.sas.com/detail/videos/sas-viya-quick-start/video/6325462141112/sas-viya-and-the-analytics-life-cycle?autoStart=true)
- [Discover Information Assets with SAS Information Catalog](https://video.sas.com/detail/videos/sas-viya-quick-start/video/6326134225112/discover-information-assets-with-sas-information-catalog?autoStart=true)
- [Explore and Visualize Data with SAS Visual Analytics](https://video.sas.com/detail/videos/sas-viya-quick-start/video/6323595794112/explore-and-visualize-data-with-sas-visual-analytics?autoStart=true)
- [Build Models with SAS Model Studio](https://video.sas.com/detail/videos/sas-viya-quick-start/video/6326334754112/build-models-with-sas-model-studio?autoStart=true)
- [Manage Models with SAS Model Manager](https://video.sas.com/detail/videos/sas-viya-quick-start/video/6326134528112/manage-models-with-sas-model-manager?autoStart=true)
- [Develop SAS Code with SAS Studio](https://video.sas.com/detail/videos/sas-viya-quick-start/video/6325460656112/develop-sas-code-with-sas-studio?autoStart=true)
- [Build Flows with SAS Studio](https://video.sas.com/detail/videos/sas-viya-quick-start/video/6325462242112/build-flows-with-sas-studio?autoStart=true)
- [Accelerate Code in SAS Cloud Analytic Services](https://video.sas.com/detail/videos/sas-viya-quick-start/video/6326133063112/accelerate-code-with-sas-cloud-analytic-services?autoStart=true)
- Prepare Data with SAS Data Studio (coming soon)
- Share and Collaborate with SAS Drive (coming soon)
- Develop Python Code with SAS Studio (coming soon)
- Use the Python SWAT Package on the SAS Viya Platform (coming soon)

### Prerequisites

It is possible your SAS Viya environmnent may already have the supporting video files loaded. To determine if the files are included, follow these steps:
1.	In SAS Viya, select the Applications menu in the upper left corner and select **Develop Code and Flows**. SAS Studio launches. 
2.	In the Navigation pane on the left, select **Explorer**. 
3.	Expand **Files** > **data** > **quick-start**. If this folder exsists, then the supporting files are loaded in your environment. 

If the files are not loaded, then follow the **Installation** steps.

### Installation

1.	Visit https://github.com/sassoftware/sas-viya-quick-start and click **Code** > **Download ZIP**. 
2.	Unzip the files to your local machine. By default, the files will be in a folder named **sas-viya-quick-start-main**.
3.	In SAS Viya, select the Applications menu in the upper left corner and select **Develop Code and Flows**. SAS Studio launches. 
4.	In the Navigation pane on the left, select the **Explorer** icon. 
5.	Expand **Files**. Navigate to your preferred location for storing the video files. You must have write access.  Right-click on the desired folder and select **New folder**. Name the folder **quick-start**.  
NOTE: The file location demonstrated in the video is **Files** > **data** > **quick-start**.
6.	Select the new **quick-start** folder and click the **Upload** button. 
7.	Click **Add**, then navigate to the files you unzipped on your local machine. Press **Ctrl+A** to select all the files, then click **Open** > **Upload**.
8.	In the Explorer, expand the **quick-start** folder and double-click the **Load_Quick_Start_Data.sas** program to open it. 
9.	Do not make any changes to the code. Click **Run**. Confirm the **home_equity.sashdat** file is listed in the CAS File Information table.  
NOTE: As you follow along in your environment, the **HOME_EQUITY** table will be in the **Casuser** caslib. 

## Contributing

We do not accept contributions for this project. 

## License

This project is licensed under the [Apache 2.0 License](LICENSE).

## Additional Resources

**Required**. Include any additional resources that users may need or find useful when using your software. Additional resources might include the following:

* *Link to videos on SAS Video Portal (once posted)*
* [SAS Viya Community](https://communities.sas.com/t5/SAS-Viya/ct-p/viya)
* [SAS Viya Learning and Support](https://support.sas.com/en/software/sas-viya.html)
