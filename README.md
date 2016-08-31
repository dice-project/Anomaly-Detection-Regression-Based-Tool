# DICE-Anomaly-Detection-Regression-Based-Tool
## Introduction
Every new code commit might potentially introduce changes resulting in the performance degradation and anomalous behaviour of the application under development. Regression-Based Anomaly Detection Tool (RBADT) aims to help software developers to flag potential anomalies at every new code deployment.


## Architecture
The high-level architecture of the tool is shown on the Figure below:

![](http://wp.doc.ic.ac.uk/dice-h2020/wp-content/uploads/sites/75/2016/08/Figure_1-e1472638202945.png)



## Installation
Regression-based Anomaly Detection tool is implemented in Matlab and packaged to be run as a standalone application from the browser or command line (does not require Matlab to be installed). MyAppInstaller_web.exe is an installer of the MATLAB Generated Standalone Application.

### Compile RBADT (for source code distribution).

If you made changes to the source code and want to compile it, Matlab provides interactive and straightforward compiling environment with the following steps:

<ol>

<li> Put all .m files you want to package as a part of an application into the same folder (Matlab compiler app automatically finds dependencies, but if you have two or more files with the same name but with different contents in different folders, Matlab will add the one which is closest on the path to the main file). </li>
<li> Open the <b>Application Compiler</b>. <br />
   a) On the toolstrip select the <b>Apps</b> tab. <br />
   b) Click <b>Application Compiler</b> to open the MATLAB Compiler</b> project window. <br />
   <img src="http://wp.doc.ic.ac.uk/dice-h2020/wp-content/uploads/sites/75/2016/08/Screen-Shot-2016-08-31-at-16.05.45.png" /> <br />
   <img src="http://wp.doc.ic.ac.uk/dice-h2020/wp-content/uploads/sites/75/2016/08/Screen-Shot-2016-08-31-at-16.13.21-e1472657140633.png" /> <br />
<br /></li>
<li> Specify the main file of the MATLAB application you want to deploy. <br />
   a) In the <b>Main File</b> section of the toolstrip, click the plus button. <br />
      <b>Note:</b>   If the Main File section of the toolstrip is collapsed, you can expand it by clicking the down arrow. <br />
   b) In the file explorer that opens, locate and select the main.m file (or whatever the name you choose for your main file). <br />
   c) Click <b>Open</b> to select the file and close the file explorer. <br />
      main.m is added to the list of main files and the plus button will be replaced by a minus button.</li>
<li> In the <b>Packaging Options</b> section of the toolstrip, verify that the <b>Runtime downloaded from web</b> check box is selected. <br />
   <b>Note:</b>   If the Packaging Options section of the toolstrip is collapsed, you can expand it by clicking the down arrow. <br />
   This option creates an application installer that automatically downloads the MATLAB Runtime and installs it along with the deployed MATLAB application. <br /> </li>
<li> Explore the main body of the <b>MATLAB Compiler</b> project window. <br />
   The project window is divided into the following areas: <br />
   
<ul>

  <li> <b>Application Information</b> — Editable information about the deployed application. This information is used by the generated installer to populate the installed application's metadata. See <a href="http://uk.mathworks.com/help/compiler/customizing-the-installer.html">Customize the Installer</a>.</li>
  <li> <b>Additional Installer Options</b> — The default installation path for the generated installer. See <a href="http://uk.mathworks.com/help/compiler/customizing-the-installer.html">Customize the Installer</a>.</li>
  <li> <b>Files required for your application to run</b> — Additional files required by the generated application. These files will be included in the generated application installer. See <a href="http://uk.mathworks.com/help/compiler/adding-required-files-to-the-project.html">Manage Required Files in Compiler Project</a>. If your tool implementation reads/writes information to/from Matlab data files (.mat) they need to be added manually here (by pressing plus button in the bottom right corner of the field). There is no need to include .txt files explicitly to this list.<br />
  <br />
  <img src = "http://wp.doc.ic.ac.uk/dice-h2020/wp-content/uploads/sites/75/2016/08/Screen-Shot-2016-08-31-at-16.25.05-e1472658301239.png" /> </li>
  <li> <b>Files installed with your application</b> — Files that are installed with your application. These files include generated <i>readme.txt</i>, generated executable for the target platform. <br /></li>
  See <a href="http://uk.mathworks.com/help/compiler/specifying-additional-files-to-be-installed-with-the-application.html">Specify Files to Install with Application</a> </li>
  <li> <b>Additional Runtime Settings</b> — Platform specific options for controlling the generated executable. See <a href="http://uk.mathworks.com/help/compiler/customizing-the-applications-runtime-behavior.html">Customize Application Runtime Settings</a>.</li>

</ul> </li>

<li> Click <b>Package</b>. <br />
   The Package window opens while the application is being generated. <br />
   <img src="http://wp.doc.ic.ac.uk/dice-h2020/wp-content/uploads/sites/75/2016/08/Screen-Shot-2016-08-31-at-16.43.51-e1472659274241.png" /> </li> <br />
<li> Select the <b>Open output folder when process completes</b> check box. <br />
   When the deployment process is complete a file explorer opens and displays the generated output. <br />
   It should contain: <br />
<ul>

   <li> <i>for_redistribution</i> folder contains the file that installs the application and the MATLAB Runtime. </li>
   <li> <i>for_testing</i> folder contains all the artifacts created by mcc like binaries and jar, header, and source files for a specific target. Use these files to test the installation. </li>
   <li> <i>for_redistribution_files_only</i> folder contains the files required for redistribute of the application.
   Distribute these files to users that have MATLAB or MATLAB Runtime installed on their machines. </li>
   <li> <i>PackagingLog.txt</i> is a log file generated by the compiler.</li>

</ul> </li>
<li> Click <b>Close</b> on the Package window. </li>

</ol>


### Install RBADT

To install RBADT on either Windows, Linux or Mac OS platforms please follow the steps outlined below*:

1. Download MyAppInstaller_web.exe, config_main.txt and config_factors.txt from this GitHub repository (or locate the MyAppInstaller_web executable in the for_redistribution folder created by the MATLAB Compiler if you have compiled the application from your own source code using instructions above).
2. Double click the installer to run it. <br />
<img src="http://wp.doc.ic.ac.uk/dice-h2020/wp-content/uploads/sites/75/2016/08/Screen-Shot-2016-08-31-at-12.13.04-e1472642089688.png" />
3. If you connect to the internet using a proxy server, enter the server's settings. <br />
   a) Click <b>Connection Settings</b>. <br />
   b) Enter the proxy server settings in the provided window. <br />
   c) Click <b>OK</b>.
4. Click <b>Next</b> to advance to the Installation Options page. <br />
<b>Note:</b>   On Linux® and Mac OS X you will not have the option of adding a desktop shortcut.
5. Click <b>Next</b> to advance to the Required Software page. <br />
   If asked about creating the destination folder, click <b>Yes</b>. <br />
<img src="http://wp.doc.ic.ac.uk/dice-h2020/wp-content/uploads/sites/75/2016/08/Screen-Shot-2016-08-31-at-12.20.31-e1472642473481.png" /> <br />
<b>Note</b>:   If the correct version of the MATLAB Runtime exists on the system, this page displays a message that indicates you do need to install a new version. <br />
<img src="http://wp.doc.ic.ac.uk/dice-h2020/wp-content/uploads/sites/75/2016/08/Screen-Shot-2016-08-31-at-12.23.54-e1472642677145.png" /> <br />
   If you receive this message, skip to step 10.
6.  Click <b>Next</b> to advance to the License Agreement page. <br />
    If asked about creating the destination folder, click <b>Yes</b>.
7.  Read the license agreement.
8.  Check <b>Yes</b> to accept the license.
9.  Click <b>Next</b> to advance to the Confirmation page.
10. Click <b>Install</b>. <br />
    The installer installs the MATLAB generated application. If needed, it also downloads and installs the MATLAB Runtime.
11. Click <b>Finish</b>. <br />

*you can also refer to the Matlab <a href="http://uk.mathworks.com/help/compiler/create-and-install-a-standalone-application-from-matlab-code.html#bt080bj-1_2">support documentation</a> (starting from the step 2).

### Configuration files

Configuration parameters for the tool are supplied via the configuration file <i>config_main.txt</i>, and input data for model training (except for observations, which are obtained from the DICE monitoring platform) via <i>config_factors.txt</i>. <br />
<b>Important!</b> These files should be placed into the same directory as an installed application. 

Configuration file <i>config_main.txt</i> contains the following parameters:

1. <b>Metric</b> - performance metric to train a statistical model for, set by the developer. Should be entered in the same syntax as it's called in the DICE monitoring platform (D-Mon). This parameter currently is not used by the tool, because it is not integrated yet with D-Mon.
2. <b>Budget_constr</b> (Yes/No). Indicates whether developer is limited by how many observation points they can obtain for the model training step (general rule: the more datapoints available - the better performance model will be, but more expensive - more times to run application under test are needed).
3. <b>Budget</b> (integer value or empty). If there is a time/money limitation on obtaining training data, indicate maximum number of experiments you can afford, else leave it empty.
4. <b>Mode</b> (manual/automated). Tool currently supports only manual mode. In this mode developer provides to the tool the list of inputs for the model training (e.g. application configuration parameters, hardware parameters etc.) with their settings (low and high) via <i>config_factors.txt</i> file (see the file for an example input). In automated mode this list will be supplied by the DICE deployment tool.
5. <b>R2</b> (default value 0.85). Parameter defining the minimum desired goodness of fit for the trained model (general rule: the lower this value, the less datapoints are needed to train the model, but the model predictive capability also diminishes).
6. <b>p_value</b> (default 0.05). Parameter defining the certainty with which the terms (from the list of input parameters) should be included into the trained model. General rule is similar to the R2: the higher this value (e.g 0.1), the less experiments would be needed to obtain observations for model fitting. However, this would increase the risk of including input parameters into the model which are noise (don't influence performance metric being modelled).
7. <b>Version_to_compare</b>. Here enter the version number of your application's deployment with which you want to compare the performance model that will be trained for your the most recent deployment. The tool will retrieve the corresponding performance model from the model repository. Currently there is no application under test and RBADT works in the demo mode (see more detailed explanation of the demo mode below).

Configuration file <i>config_factors.txt</i> contains five Spark configuration parameters with settings (low and high) for the open-source Machine Learning application <a href="oryx.io">Oryx 2</a>. Oryx 2 was run with all possible combinations of these settings (32) to obtain datapoints of the batch processing time metric simulating Data-Intensive Application (DIA) under test for the RBADT. Where in the software development environment the tool will be running the DIA and collecting one data point per each model training step from the monitoring platform, in the current version it's picking one datapoint from this 32 observations' dataset. The Oryx 2 dataset serves as a demo and this feature will be replaced with the interfaces to the DICE deployment tool and DICE monitoring platform on the integration stage (see more detailed explanation of the demo mode below).


### Run RBADT

After the tool is installed and configuration files are added and modified to the developer's specifications, RBADT can be executed by running RBAD.exe file by clicking on it in browser window or providing the path to it in the command line.

If you choose to run the RBAD tool in command line, please refer to the following steps:

<ol>

<li> Open a terminal window.</li>
<li> Navigate to the folder into which you installed the application. <br />
   If you accepted the default settings, you can find the folder in one of the following locations: <br />
<table>

<tr>

<td>Windows</td>
<td>C:\Program Files\RBAD</td>

</tr>

<td>Mac OS X</td>
<td>/Applications/RBAD</td>

<tr>

<td>Linux</td>
<td>/usr/RBAD</td>

</tr>


</table> </li>
<li> Run the application using the one of the following commands: <br />

<table>

<tr>

<td>Windows</td>
<td>application\RBAD</td>

</tr>

<td>Mac OS X</td>
<td>./RBAD.app/Contents/MacOS/RBAD</td>

<tr>

<td>Linux</td>
<td>./RBAD</td>

</tr>


</table>

</li>

<ol>

## Demo mode

As there are currently no DIA in development to test for anomalies or anomalies-injection tool available, as well as RBADT is not yet integrated with other DICE tools, the tool works in the demo mode. This includes: <br />
1. DIA performance model is created using (some) observations from the 32-point dataset obtained by running Oryx 2 (instead of running a DIA each time when a datapoint is needed and collecting it from the D-Mon). <br />
2. Versioned model repository is implemented as a readable/writable data structure (cell array), where model of the previous deployment (version_to_compare=1) is the Oryx 2 performance model (for batch processing times) with an addition of the term -40*executor-cores (to generate the report message after the comparison of two models). <br />
3. The trained model is not saved into the model repository (this functionality is implemented, but commented out), because it will be the same on every tool execution. 

## Report generation

In the integrated mode it is envisioned that RBADT will be providing information that will be displayed either in D-Mon or DICE IDE. For now the tool generates a <i>report*.txt file</i>, where * stands for the current deployment version. The file contains one or more of the following messages:

<table>

<tr>

<td>a)</td>
<td>The problem is in *name of the input parameter(s)*</td>
<td>If the tool detected performance degradation caused by the change in this input parameter (or multiple parameters)</td>

</tr>

<tr>

<td>b)</td>
<td>Disappearance of *name of the input parameter(s)* caused anomalous behaviour</td>
<td>If one or more input parameters were present in the "old" model and its (their) disappearance caused performance degradation</td>

</tr>

<tr>

<td>c)</td>
<td>Appearance of *name of the input parameter(s)* caused anomalous behaviour</td>
<td>If one or more input parameters were absent in the "old" model and its (their) appearance caused performance degradation</td>

</tr>

</table>

If no anomalies detected the file will report "No anomalies detected".

The report generated by this demo version returns the message from the case b), because model of the version 1 contained the artificially added term "-40*executor-cores", which was significantly reducing batch processing time. It does not exist in the real (Oryx 2) model, therefore the relevant message was generated. <br />
<img src="http://wp.doc.ic.ac.uk/dice-h2020/wp-content/uploads/sites/75/2016/08/Screen-Shot-2016-08-31-at-13.50.50-e1472649363777.png" /> <br />

For more information on the architecture, functionality algorithms employed in the tool please refer to the DICE <a href="http://wp.doc.ic.ac.uk/dice-h2020/wp-content/uploads/sites/75/2016/08/D4.3-Quality-anomaly-detection-and-trace-checking-tools-Initial-version.pdf">deliverable D4.3</a>.

# Contact

If you notice a bug, want to request a feature, or have a question or feedback, please send an email to the tool maintainer:

Tatiana Ustinova, Imperial College London, t.ustinova@imperial.ac.uk

# License

The code is published under the <a href="https://github.com/dice-project/DICE-Anomaly-Detection-Regression-Based-Tool/blob/master/License.txt">FreeBSD License</a>.


