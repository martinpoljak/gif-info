# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "gif-info/block"
require "gif-info/body"

##
# Primary GifInfo module.
#

module GifInfo

    ##
    # Abstract block which contains data in {Body} form only.
    # @abstract
    #
    
    class DataBlock < Block
    
        ##
        # Data body content.
        #
        
        @body
        
        ##
        # Returns data body.
        # @return [Body] data body
        #
        
        def body
            if @body.nil?
                @body = Body::new(@io)
            end
            
            return @body
        end
        
        ##
        # Skips block in stream.
        #
        
        def skip
            self.body.skip
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
