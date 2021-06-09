begin
	gtp = Array{Any}(undef,24)
	dcp = Array{Any}(undef,24)
	scp = Array{Any}(undef,24)
	@inbounds for i in 1:24
		gtp[i]=convert(DIN99o,groundtruth_patches[i])
		scp[i]=convert(DIN99o,source_patches[i])
		dcp[i]=convert(DIN99o,dest_patches[i])
	end
	WPconv=convert(DIN99o,sWP)
	# create a99* and b99* vectors
	
	for i in 1:24
		
	Lgt=map(1:24) do i gtp[i].l end
	agt=map(1:24) do i gtp[i].a end
	bgt=map(1:24) do i gtp[i].b end
	Ldc=map(1:24) do i dcp[i].l end
	adc=map(1:24) do i dcp[i].a end
	bdc=map(1:24) do i dcp[i].b end
	Lsc=map(1:24) do i scp[i].l end
	asc=map(1:24) do i scp[i].a end
	bsc=map(1:24) do i scp[i].b end
	aq= map(1:24) do i agt[i], adc[i] end
	bq= map(1:24) do i bgt[i], bdc[i] end
	Lq= map(1:24) do i Lgt[i], Ldc[i] end
	aline= map(1:24) do i collect(aq[i]) end
	bline= map(1:24) do i collect(bq[i]) end
	Lline= map(1:24) do i collect(Lq[i]) end
	end
	
	scatter(zeros(1),zeros(1),#=zeros(1),=# color=DIN99o(60,0,0),markersize=1, shape = :hexagon,  label="neutral axis",title="Color coordinates in DIN99o color space",legend=:bottomleft, #=aspect_ratio= :equal,=#background=DIN99o(40,0,0),xaxis="a*",yaxis="b*", zaxis="L*", size=(700,700),#=xlimits=(-60,60),ylimits=(-60,60),camera=(0,0)=#)
	scatter!(gtp.a,gtp.b,gtp.l, color=gtp,markersize=2, markershape = :square, label="ground truth")
	scatter!(dcp.a,dcp.b,dcp.l, color=dcp,markersize=1, shape = :circle, label="destination color")
	plot!(aline,bline,Lline, color=:black, linewidth= 3,label=false)
	scatter!([WPconv.a],[WPconv.b],[WPconv.l],color= WPconv, markersize= 2, label="Source White Point")
	#quiver!(a99gt,b99gt,L99gt,quiver=(a99dc-a99gt,b99dc-b99gt,L99dc-L99gt),color=:black,arrowsize=5,marker=:none)
end