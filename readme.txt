================================================================================

                                    PascalSDK

                       Translation of SCS SDK into Pascal

================================================================================

Description
------------------------------
The SCS SDK, as provided by the SCS Software company, is a collection of APIs
designed to allow data exchange and communication between a running game and
a dynamic library loaded by this game. This dynamic library can use these APIs
to provide additional functionality to the game, provide extensive logging, and
more. The APIs are defined in a set of several C header files (eg. "scssdk.h"),
which are declaring number of constants, types and also a flat procedural
interface. Currently (february 2023), this mechanism is supported by Euro Truck
Simulator 2 and American Truck Simulator.

PascalSDK project provides a pascal translation of the entire SDK for use in
Delphi (version 7 or newer) and Free Pascal Compiler (FPC version 2.6.4 or
newer) - possibly running under Lazarus IDE.

Current version of PascalSDK (1.0) is based on SCS SDK version 1.14.



Important disclaimer
------------------------------
The entire development of this project was done "in the blind" - that is, with
absolutely no access to internet or other information channels and with no
access to instalations of relevant games (ETS2, ATS).
This means, among others, that the translated headers were not actively tested
beyond the fact that they can be compiled.

Also, due to mentioned lack of access to proper active testing (ie. running the
code on the actual game), it was decided to drop translation of examples that
are part of the original SDK. They may be added later, if situation allows it.



Technical details
------------------------------
The translation is provided in two main forms. First is a one-to-one
translation of the original headers, where each "*.h" file is translated into
a corresponding "*.pas" file. These files are located in folder called
"headers" within the project root.

As there are no true header files in pascal, it is not common to do agressive
separation into individual files (like in the first form), but rather to place
everything into one unit, if feasible, and use only this one in uses clause.
The second form is this combination of all translated headers into one pascal
unit, and is stored in file "headers_condensed/PascalSDK.pas".

Whatever form you decide to use is only up to you, but using the condensed unit
is recommended.

Program used to automatically condense the translated headers with a few other
supporting files is stored in folder "condenser" - note that this folder is not
present in "master" branch of the project, but is maintained in a branch called
"condenser".
Full source code of the mentioned program can be found in the following
repository:

  https://github.com/TheLazyTomcat/PascalSDK_Headers_Condenser



Project files
------------------------------
List of folders with description of their content:

  ./

    Root folder. Contains license and readme files.

  ./condenser

    Condeser program and supporting files (only in branch "condenser").

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
You can get actual copy of this project on the following git repository:

  https://github.com/TheLazyTomcat/PascalSDK



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