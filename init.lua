minetest.register_privilege("node_admin", {
    description = "Allows the player to use the node admin tool to dig any node and collect it.",
    give_to_singleplayer = false, -- Whether to give this privilege to singleplayer mode automatically
    give_to_admin = true, -- Whether to give this privilege to admin players automatically
})

minetest.register_tool("node_admin:dig_any_node_tool", {
    description = "Dig Any Node Tool",
    inventory_image = "default_tool_stonepick.png^[colorize:black:200",
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type ~= "node" then
            return
        end

        local player_name = user:get_player_name()
        if minetest.check_player_privs(player_name, {node_admin = true}) then
            local pos = pointed_thing.under
            local node = minetest.get_node(pos)
            if node and node.name then
                -- Add the node to player's inventory
                local inv = user:get_inventory()
                if inv:room_for_item("main", node.name) then
                    inv:add_item("main", node.name)
                    minetest.set_node(pos, {name = "air"})
                    minetest.chat_send_player(player_name, "Node dug successfully and added to your inventory.")
                else
                    minetest.chat_send_player(player_name, "No room in inventory to add the node.")
                end
            end
        else
            minetest.chat_send_player(player_name, "You do not have the node_admin privilege.")
        end
    end,
})

minetest.register_tool("node_admin:node_info_tool", {
    description = "Node Info Tool",
    inventory_image = "default_tool_stonesword.png^[colorize:black:200",
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type ~= "node" then
            return
        end

        local player_name = user:get_player_name()
        if minetest.check_player_privs(player_name, {node_admin = true}) then
            local pos = pointed_thing.under
            local node = minetest.get_node(pos)
            if node and node.name then
                local node_def = minetest.registered_nodes[node.name]
                local node_groups = node_def.groups
                local groups_str = ""

                for group, value in pairs(node_groups) do
                    groups_str = groups_str .. group .. " (level " .. value .. "), "
                end

                if groups_str == "" then
                    groups_str = "No groups"
                else
                    groups_str = groups_str:sub(1, -3) -- Remove the trailing comma and space
                end

                minetest.chat_send_player(player_name, "Node: " .. node.name .. "\nGroups: " .. groups_str)
            end
        else
            minetest.chat_send_player(player_name, "You do not have the node_admin privilege.")
        end
    end,
})
