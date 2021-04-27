# record_your_voice

Project Documentation

This is a Voice Recording app that has been built with CRUD UI where user can Create, Read, Update & Delete a file. Here user can record his voice and play it back.  The recorded audio file can be cropped and saved in the device and can play it as well. User has the option to Edit or Delete by swiping on the recorded file.

In this project MVVM (Model-View-ViewModel) design pattern has been adopted as this architecture has benefits in testing purpose. As the ViewModel is pure NSObject, it is not coupled with our UIKit code. As a result, it can be tested more easily in our unit tests without affecting the UI coding. We can change one layer without affecting the other layers.
