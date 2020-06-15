# AOIL - Politecnico di TOrino
# home-made implementation of a priority queue
# the tricky part is to keep track of indices
# so as to be able to update values

struct HeapNode{W}
    w::W
    i::Int
end

struct Heap{W}
    q::Vector{HeapNode{W}}
    l::Vector{Int}
end

Heap(::Type{W}, n::Int) where W = Heap(HeapNode{W}[], fill(0, n))

Base.length(h::Heap) = Base.length(h.q)

function Heap(x::AbstractVector{W}) where W
    h = Heap(W, length(x))
    for i=1:length(x)
        push!(h, i, x[i])
    end
    h
end

function swap!(h::Heap, i, j)
    @assert i > 0 && j > 0
    q, l = h.q, h.l
    q[i], q[j] = q[j], q[i]
    l[q[i].i], l[q[j].i] = l[q[j].i], l[q[i].i]
end

function heapify_up!(h::Heap, i)
    while i > 1 && h.q[i].w < h.q[i÷2].w
        swap!(h, i, i÷2)
        i ÷= 2
    end
end

function heapify_down!(h, node)
    while true
        l, r = node * 2, node * 2 + 1;
        lw = l <= length(h) ? h.q[l].w : Inf;
        rw = r <= length(h) ? h.q[r].w : Inf;
        h.q[node].w <= min(lw, rw) && break
        target = lw < rw ? l : r
        swap!(h, node, target);
        node = target;
    end
end

function Base.push!(h::Heap, idx, w)
    push!(h.q, HeapNode(w, idx))
    h.l[idx] = length(h)
    heapify_up!(h, length(h))
end

function decrease_value!(h, idx, wnew)
    node = h.l[idx]
    @assert h.q[node].i == idx
    h.q[node] = HeapNode(wnew, idx)
    heapify_up!(h, node)
end

function Base.pop!(h::Heap)
    @assert length(h) > 0
    o = h.q[1]
    swap!(h, 1, length(h.q))
    pop!(h.q)
    length(h.q) > 1 && heapify_down!(h, 1)
    return o
end

peek(h::Heap, idx) = h.q[h.l[idx]].w

