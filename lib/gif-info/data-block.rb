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
        # Constructor.
        # @param [IO] io IO object
        #
        
        def initialize(io)
            super(io)
            self.body
        end
        
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
        # Returns block size.
        # @return [Integer] block size in bytes
        #
        
        def bytesize
            self.body.bytesize
        end
    end
end
