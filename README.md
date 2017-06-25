# TigerVNC-Manager
<p align="center"><img src="https://user-images.githubusercontent.com/26261213/27513996-d67918f0-5941-11e7-8435-32d4f51f2df5.JPG" /></p>

A GUI for TigerVNC built on powershell and winforms.

TigerVNC Manager allows you to save all of TigerVNC's standard settings as profiles, for individual sessions. The profiles are saved in the same .tigervnc format as the original application. When a profile is loaded from the file, all settings are converted to a properly formatted argument list and passed to the vncviewer executable. If you wish to import previously made .tigervnc files, simply copy them into either the default save directory specified under options, or the path you configured yourself. As long as they have the .tigervnc extension, they should automatically be imported when the program is launched.


To Initiate a Connection you can use 1 of 3 methods depending on the scenario.
1. New Connection: Simply fill in the IP and Port as [IP]:[Port], then click the Connect button that is in the "New Connections" box. Filling in the Hostname is only necessary if you decide to save the connection, which it will use as the Name for the profile.

2. Saved Connections(Method 1): Once a connection is saved, selecting it will populate the adjacent Hostname & IP fields, as well as it's saved options under the options tab. Once loaded, clicking the Connect button at the bottom of the "Saved Connections" box will initiate the connection.

3. Saved Connections(Method 2): The quicker way to connect! Simply double click on the desired Profile name, and it will initiate the connection.
