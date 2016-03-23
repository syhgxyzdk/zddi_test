# encoding: utf-8
require File.dirname(__FILE__) + '/dns'

module ZDDI
    module Address
        extend self
        def open_address_page
            ZDDI.browser.link(:class, 'address').click
            sleep 1
        end
        def open_page_by_cls_name(cls_name)
            open_address_page
            ZDDI.browser.link(:class, cls_name).click
            sleep 1
            # DNS.wait_for_page_present(cls_name)
        end
        def open_network_page
            open_page_by_cls_name('networks')
        end
        def open_network_page_2
            #
        end
        def open_address_range_page
            open_page_by_cls_name('address-range')
        end
        def inputs_create_network(args)
            DNS.popup_right_menu
            DNS.popwin.text_field(:name=>"name").set(args[:network])
            DNS.select_owner(args)
        end
        def select_network(args)

        end
        def goto_network_page(args)

        end
        def goto_address_page(args)

        end
        ######################   IPAM   ##########################
        class IPAM
            def create_network(args)
                Address.open_network_page
                Address.inputs_create_network(args)
                r = DNS.waiting_operate_finished ? 'fail' : 'succeed'
                puts "#{r} to create IPAM network: #{args[:network]}"
                r
            end
            def modify_network_memeber(arg)
                Address.open_network_page
                Address.select_network(args)
            end
            def del_network(args)

            end
        end
    end
end