# TigerVNC-Manager
![alt text](https://user-images.githubusercontent.com/26261213/27513996-d67918f0-5941-11e7-8435-32d4f51f2df5.JPG)
A GUI for TigerVNC built on powershell and winforms.

TigerVNC Manager allows you to save all of TigerVNC's standard settings as profiles, for individual sessions. The profiles are saved in the same .tigervnc format as the original application. When a profile is loaded from the file, all settings are converted to a properly formatted argument list and passed to the vncviewer executable. If you wish to import previously made .tigervnc files, simply copy them into either the default save directory specified under options, or the path you configured yourself. As long as they have the .tigervnc extension, they should automatically be imported when the program is launched.
