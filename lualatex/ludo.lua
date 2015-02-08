oldprint = print

function print(args)
  if tex then
    tex.print(args)
  else
    oldprint(args)
  end
end

function factorial(n)
   if n == 0 then
     return 1
   end
 
   return n * factorial(n - 1)
 end

 function fact_series(n)
  for i=1,n,1 do
    tex.print("", i, factorial(i), ";")
  end
 end

 function draw_node(node, color)
     color = color or "red!20"
     print(string.format("\\node[draw, circle, fill=%s] at (%f, %f) (%s) {$%s$};",color,node._x, node._y, node.label, node.caption))
 end

function draw_rect(node, color)
     color = color or "red!20"
     print(string.format("\\node[draw, fill=%s] at (%f, %f) (%s) {$%s$};",color,node._x, node._y, node.label, node.caption))
 end


 function connect_nodes(n1, n2)
     print(string.format("\\draw[] (%s) --  (%s);",n1.label, n2.label))
 end

 local node_id = 0
 function create_node(x, y, cap)
    cap = cap or ""
    node = {_x = x, _y = y, label = string.format("node%d",node_id), caption = cap}
    node_id = node_id + 1
    return node
 end

 function rand_nodes(n)
   nodes = {}
   for i=1,n,1 do
     nodes[i] = create_node(20*math.cos(0.02*i), 40*math.sin(0.1*i))
   end

   for i=1,n,1 do
     draw_node(nodes[i])
   end

   for i = 0,n-1,1 do
     connect_nodes(nodes[i], nodes[i+1])
   end
 end

 function preamble() 
  print("\\documentclass[]{standalone}")
  print("\\usepackage{tikz}")
  print("\\usetikzlibrary{arrows,shapes,snakes,automata,backgrounds,petri}")
  print("\\usepackage{animate}")
 end

 function begin_doc()
   print("\\begin{document}")
 end

 function end_doc()
  print("\\end{document}")
 end

 function factor_graph(n,dist,p)
   poses = {}
   z1 = {}
   z2 = {}

   m1 = {}
   m2 = {}


   for i=1,n,1 do
     poses[i] = create_node(2*i, 0,  string.format("x_{%d}",i))
     draw_node(poses[i])
   end
   for i=1,n-1,1 do
     z1[i] = create_node(2*i+1, dist, string.format("v_{%d}",i))
     draw_rect(z1[i], "blue!20")
   end

   for i=1,n-2,1 do
     z2[i] = create_node(2*i+2, -dist, string.format("a_{%d}",i))
     draw_rect(z2[i], "blue!20")
   end


   for i=1,n-1,1 do
     connect_nodes(poses[i],z1[i])
     connect_nodes(poses[i+1],z1[i])
   end

   for i=1,n-2,1 do
     connect_nodes(poses[i],z2[i])
     connect_nodes(poses[i+1],z2[i])
     connect_nodes(poses[i+2],z2[i])
   end

   m1[0] = create_node(2*n/3+1, 2*dist, string.format("p_1"))
   m1[1] = create_node(4*n/3+1,2*dist, string.format("p_2"))
   m2[0] = create_node(2*n/2+1, -2*dist, string.format("p_3"))

   draw_node(m1[0], "green!20")
   draw_node(m1[1], "green!20")
   draw_node(m2[0], "green!20")

   for i=1,n-1,1 do
     connect_nodes(m1[0], z1[i])
     connect_nodes(m1[1], z1[i])
   end

  for i=1,n-2,1 do
     connect_nodes(m2[0], z2[i])
   end
 end


 function factor_fig(n,dist)
  print("\\begin{tikzpicture}[]")
  factor_graph(n,dist,1)
  print("\\end{tikzpicture}")
 end

 function create_doc(args)
   preamble()
   begin_doc()
   factor_fig(6,2)
   end_doc()
 end
