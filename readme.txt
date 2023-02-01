================================================================================
                                  TelemetrySDK
================================================================================

Description
------------------------------
The SCS SDK, as provided by the SCS Software company, is a collection of APIs
designed to allow data exchange and communication between a running game and
a dynamic library loaded by this game. This dynamic library can use the APIs to
provide additional functionality the game lacks, provide extensive logging, and
more. The APIs are defined in a set of several C header files (eg. "scssdk.h"),
which are declaring number of constants, types and also a flat procedural
interface. Currently (january 2023), this mechanism is supported by Euro Truck
Simulator 2 and American Truck Simulator.

TelemetrySDK project aims to provide a pascal translation of the entire SDK for
use in Delphi (version 7 or never) and Free Pascal Compiler (FPC version 2.6.4
or never) - possibly running under Lazarus IDE.

As for the name of this project - I am fully aware that the latest SDK contains
not only the telemetry part, but also input API. The project was started way
before input was included, and I don't want rename it just yet, therefore the
name is staying as is. But of course, the APIs other than telemetry are
translated too.

Current version of TelemetrySDK (1.0) is based on SCS SDK version 1.14.




Important disclaimer
------------------------------
The entire development of this project was done "in the blind" - that is, with
absolutely no access to internet or other information channels and with no
access to instalations of affected games (ETS2, ATS).
This means, among others, that the translated headers were not actively tested
beyond the fact that they can be compiled.

Also, due to mentioned lack of access to proper active testing (ie. running the
code on the actual games), it was decided to drop translation of examples that
are part of the original SDK. They may be added later, if situation allows it.



Parts of the project
------------------------------
At this moment, there are two parts of this project:

  First is a one-to-one translation of the original headers, where each "*.h"
  file is translated into a corresponding "*.pas" file. These files are located
  in folder called "headers" within the project root.

  Second part is a condensed form of all the translated headers, it completely
  resides in the file "headers_condensed/TelemetrySDK.pas".
  As there are no true header files in pascal, it is not common to do agressive
  separation into individual files, but rather to place everything into one
  unit, if feasible, and use this one in uses clause. The "TelemetrySDK.pas"
  is such a unit.

Whatever part you decide to use is only up to you, but using the condensed unit
is recommended.

The last thing, though not direct part of this project, is a program that is
used to automatically condense the translated headers.
The program and a few other supporting files are stored in folder "condenser".
This folder is not present in "master" branch of the project, but is maintained
in a branch called "condenser".
Full source code of the mentioned program can be found in the following
repository:

  https://github.com/TheLazyTomcat/TelemetrySDK_Headers_Condenser

Note that the "master" branch of that repository does not contain any binaries,
they can be found in a branch "bin".



Project files
------------------------------
List of folders with description of their content:

  ./

    Root folder. Contains license and readme files.

  ./condenser

    Condeser program and supporting files (only in branch "condeser").

  ./examples

    Translated examples showing how to use the provided APIs (not implemented).

  ./headers

    One-to-one translation of all header files.

  ./headers_condensed

    All headers combined into one pascal unit.

  ./headers_original

    Original sources of the SCS SDK (zip archives).   



Repositories
----------------------------------------
You can get actual copy and source code of this project on the following git
repository:

  https://github.com/TheLazyTomcat/TelemetrySDK



Licensing
----------------------------------------
Everything, with exceptions noted further, is licensed under Mozilla Public
License Version 2.0. You can find full text of this license in file license.txt
or on web page https://www.mozilla.org/MPL/2.0/.

Files (zip archives) within folder "headers_original" contain original SDK as
provided by the SCS Software, and are therefore not covered by the MPL 2.0
license that is otherwise applicable to files within this project.
See content of these archives for information about applicable license(s).



Authors, contacts, links
----------------------------------------
František Milt, frantisek.milt@gmail.com

If you find this project useful, please consider making a small donation using 
the following link:

  https://www.paypal.me/FMilt



Copyright
----------------------------------------
©2023 František Milt, all rights reserved