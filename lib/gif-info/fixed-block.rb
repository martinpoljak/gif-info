# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "struct-fx"     # 0.1.1
require "gif-info/block"

##
# Primary GifInfo module.
#

module GifInfo

    ##
    # Abstract fixed-size block which contains header only. 
    # @abstract
    #
    
    class FixedBlock < Block
    
        ##
        # Holds header.
        #
        
        @header
        
        ##
        # Holds header struct.
        #
        # In case, data are loaded, @header and @struct links to the 
        # same objects.
        #
        
        @struct
        
        ##
        # Returns header struct.
        # @return [StructFx] struct
        #
        
        def header
            if @header.nil?
                self.prepare!
                @header = __struct
                @header << @io.read(@header.bytesize)
            end
            
            @header
        end
        
        ##
        # Skips block in stream.
        #
        
        def skip!
            @io.seek(__struct.bytesize, IO::SEEK_CUR)
        end
        
        ##
        # Returns block size.
        # @return [Integer] block size in bytes
        #
        
        def bytesize
            self.header.bytesize
        end
        
        
        private
        
        ##
        # Returns header struct.
        #
        
        def __struct
            if @struct.nil?
                @struct = StructFx::new(&self.class::STRUCTURE)
            end
            
            @struct
        end
    end
end
