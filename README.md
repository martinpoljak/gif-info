Gif Info
========

**gif-info** is analyzer of the [GIF image format][1]. It performs complete 
analysis of internal GIF block structure and streams it as an "object 
stream" with metainformations of each block. Also can *interpret* internal 
structure by providing the simple object-like interface to base image 
file informations. Works above all seekable IO streams, so allows 
processing of the big files too. Doesn't perform [LZW][2] decompressing, 
returns raw data for both color tables and images.

Two different approaches are available: **sequential** and **static**. 
First one yields "stream" of objects which are equivalent to functional 
blocks in the GIF file and which contain low-level GIF data. It's 
equivalent of for example [SAX][3] parser although, of sure, less 
complex. The other one provides classical single object-like access to 
interpreted file informations. 

Examples of both are available in the `bin` directory. `git-info` 
command writes out content of the static information object, `git-dump`
dumps content of low level blocks stream.

Modifiing the file and writing changes back is possible (see [StructFx][5]
library documentation). It isn't implemented directly by this library,
but should be easy to implement it if you will need it -- with exception
of data blocks as comments or image data -- it's necessary split them 
to blocks manually in your writing routine. Other structures provided
by the library contains binary serialization routines implicitly.

Copyright
---------

Copyright &copy; 2011 &ndash; 2016 [Martin Poljak][7]. See `LICENSE.txt` for
further details.

[1]: http://www.matthewflickinger.com/lab/whatsinagif/
[2]: https://en.wikipedia.org/wiki/LZW
[3]: https://en.wikipedia.org/wiki/Simple_API_for_XML
[4]: https://en.wikipedia.org/wiki/Document_Object_Model
[5]: https://github.com/martinkozak/struct-fx
[6]: https://github.com/martinkozak/gif-info/issues
[7]: https://www.martinpoljak.net/
