### Todo Item

# Model

immutable TodoItem <: Component
    done::Bool
    desc::String
end

const emptyitem = TodoItem(false, "")

# View

function view(i::TodoItem)
    actions = collector(:todoitem)

    ui = hbox(
        intent(Check, checkbox(i.done)) >>> actions,
        hskip(1em),
        intent(EditDesc, textinput(i.desc)) >>> actions
    ) |> packacross(center)

    intent(actions, ui)
end

# Update

immutable Check <: Action
    state::Bool
end

immutable EditDesc <: Action
    desc::String
end

update(x::TodoItem, a::Check) = TodoItem(a.state, x.desc)
update(x::TodoItem, a::EditDesc) = TodoItem(x.done, a.desc)

