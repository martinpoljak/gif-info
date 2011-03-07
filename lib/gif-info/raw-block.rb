# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "gif-info/block"

##
# Primary GifInfo module.
#

module GifInfo

    ##
    # Abstract block which contains only datas in non-formatted form,
    # so data which aren't encoded in block form as usuall in GIF.
    # Typicall example are color tables which site is known in forward.
    #
    # @abstract
    #
    
    class RawBlock < Block
    
        ##
        # Data body of block.
        #
        
        @body
        
        ##
        # Indicates length of the data for read.
        #
        
        @size
        
        ##
        # Constructor.
        #
        # @param [IO] io IO object
        # @param [Integer] size amount of data for read
        #
        
        def initialize(io, size)
            @size = size
            super(io)
        end
        
        ##
        # Returns data body.
        # @return [String] raw data
        # 
        
        def body
            if @body.nil?
                self.prepare!
                @body = @io.read(@size)
            end
            
            return @body
        end

        ##
        # Skips block in stream.
        #
        
        def skip
            @io.seek(@size, IO::SEEK_CUR)
        end
        
        ##
        # Returns block size.
        # @return [Integer] block size in bytes
        #
        
        def bytesize
            self.body.bytesize
        end
    end
end

