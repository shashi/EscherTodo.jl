
### TodoList

# Model

immutable TodoList <: Component # Maybe annotate this as a List conainer model?
    title::AbstractString
    children::PersistentVector
end

# View

function view(l::TodoList)
    actions = collector(:todolist)

    items = map(1:length(l.children)) do idx
        c = l.children[idx]
        intent(a -> ChildAction(idx, a), view(c)) >>> actions
    end

    add_btn = intent(constant(Insert(length(l.children), emptyitem)), iconbutton("add")) >>> actions
    all_btn = intent(constant(CheckAll()), iconbutton("done-all")) >>> actions

    list_ui = vbox(
        toolbar([
            add_btn,
            all_btn
        ]),
        vbox(items)
    )

    intent(actions, list_ui |> Escher.pad(1em))
end

# Update

immutable Insert <: Action
    idx::Int
    item
end

function update(l::TodoList, a::Insert)
    TodoList(l.title, vcat(l.children[1:a.idx], a.item, l.children[a.idx+1:length(l.children)]) |> pvec)
end

immutable Delete <: Action
    idx::Int
end

function update(l::TodoList, x::Delete)
    TodoList(l.title, vcat(l.children[1:a.idx-1], l.children[a.idx+1:length(l.children)]) |> pvec)
end

immutable ChildAction <: Action
    idx::Int
    action::Action
end

function update(parent::TodoList, a::ChildAction)
    TodoList(
        parent.title,
        assoc(parent.children, a.idx, update(parent.children[a.idx], a.action)))
end

immutable CheckAll
end

function update(l::TodoList, ::CheckAll)
    TodoList(l.title, pvec([TodoItem(true, x.desc) for x in l.children]))
end
