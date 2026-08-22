local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    -- Basic println
    s("rpl", {
        t('println!("'),
        i(1, "value: {:?}"),
        t('", '),
        i(2, "var"),
        t(");"),
    }),

    s("pl", fmt([[println!("{} = {{}}", {});]], {
        i(1, "var"),
        i(2, "var"),
    })),

    -- Smart debug println
    s("rpd", fmt([[println!("{} = {{:?}}", {});]], {
        i(1, "var"),
        i(2, "var"),
    })),
}
