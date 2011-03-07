# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "gif-info/fixed-block"

##
# Primary GifInfo module.
#

module GifInfo

    ##
    # Abstract block which contains both header and data with dynamic 
    # (non-fixed) length.
    #
    # @abstract
    #
    
    class DynamicBlock < FixedBlock
    
        ##
        # Holds data body.
        #
        
        @body
        
        ##
        # Returns data body.
        #
        # @param [Integer] skip number of bytes to skip before data
        # @return [Body] data body
        #
        
        def body(skip = nil)
            if @body.nil?
                if not skip.nil?
                    @io.seek(skip, IO::SEEK_CUR)    # skips dummy leader
                end
                @body = Body::new(@io)
            end
            
            @body
        end
        
        ##
        # Skips block in stream.
        #
        
        def skip(additional = nil)
            super()
            if not additional.nil?
                @io.seek(additional, IO::SEEK_CUR) 
            end
            self.body.skip
        end
                
        ##
        # Returns block size.
        # @return [Integer] block size in bytes
        #

        def bytesize
            self.header.bytesize + self.body.bytesize
        end
    end
end
