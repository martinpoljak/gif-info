# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "stringio"
require "struct-fx"

require "gif-info/blocks/header-block"
require "gif-info/blocks/logical-screen-descriptor"
require "gif-info/blocks/global-color-table"
require "gif-info/blocks/local-color-table"
require "gif-info/blocks/plain-text-extension"
require "gif-info/blocks/comment-extension"
require "gif-info/blocks/application-extension"
require "gif-info/blocks/graphics-control-extension"
require "gif-info/blocks/image-descriptor"
require "gif-info/blocks/image-data"
require "gif-info/blocks/trailer"

##
# Primary GifInfo module.
#

module GifInfo

    ##
    # Defines structure of the block head.
    #
    
    BLOCK_HEAD = StructFx::new do
        uint8 :block_introducer
        uint8 :extension_label
    end
    
    ##
    # Parses the GIF file.
    #
    # @param [IO] io IO object where offset 0 is start of the GIF file
    # @yield [Blocks::ApplicationExtension]
    # @yield [Blocks::CommentExtension]
    # @yield [Blocks::GlobalColorTable]
    # @yield [Blocks::GraphicsControlExtension]
    # @yield [Blocks::HeaderBlock]
    # @yield [Blocks::ImageData]
    # @yield [Blocks::ImageDescriptor]
    # @yield [Blocks::LocalColorTable]
    # @yield [Blocks::LogicalScreenDescriptor]
    # @yield [Blocks::PlainTextExtension]
    # @yield [Blocks::Trailer]
    # @see http://www.matthewflickinger.com/lab/whatsinagif/
    #
    
    def self.parse(io)
        if io.kind_of? String
            io = StringIO::new(io)
        end
        
        # Header Block
        yield Blocks::HeaderBlock::new(io)
        
        # Logical Screen Descriptor
        yield lsd = Blocks::LogicalScreenDescriptor::new(io)

        # Global Color Table
        if lsd.header.data.packed.data.global_color_table
            size = lsd.header.data.packed.data.global_color_table_size
            yield Blocks::GlobalColorTable::new(io, size)
        end

        # Extensions
        reader = self::BLOCK_HEAD
        length = reader.length

        loop do
            reader << (io.read(length) << "\0")     # adds zero character for cases, trailer is last byte of the file
            header = self::BLOCK_HEAD.data
            io.seek(-length, IO::SEEK_CUR)

            case header.block_introducer
                when 0x21   # extension
                    case header.extension_label
                        when 0xF9   # graphics control
                            yield Blocks::GraphicsControlExtension::new(io)
                        when 0xFF   # application
                            yield Blocks::ApplicationExtension::new(io)
                        when 0xFE   # comment
                            yield Blocks::CommentExtension::new(io)
                        when 0x01   # plain text
                            yield Blocks::PlainTextExtension::new(io)
                        else
                            raise Exception::new("Invalid format: 0x01, 0xF9, 0xFE or 0xFF expected, but 0x" << header.block_introducer.to_s(16).upcase << " found at position " << (io.pos + 1).to_s << ".")
                    end
                    
                when 0x2C   # image descriptor
                
                    # Image Descriptor
                    yield desc = Blocks::ImageDescriptor::new(io)
                    
                    # Local Color Table
                    if desc.header.data.packed.data.local_color_table
                        size = lsd.header.data.packed.data.local_color_table_size
                        yield Blocks::LocalColorTable::new(io, size)
                    end
                    
                    # Image Data
                    yield Blocks::ImageData::new(io)

                when 0x3B   # trailer
                    yield Blocks::Trailer::new(io)
                    break
                    
                else
                    raise Exception::new("Invalid format: 0x21, 0x2C or 0x3B expected, but 0x" << header.block_introducer.to_s(16).upcase << " found at position " << io.pos.to_s << ".")
            end
        end
        
    end
end
