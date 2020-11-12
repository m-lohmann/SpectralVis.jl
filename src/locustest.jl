#using GRUtils
#using Plots
#pyplot()
function locustest()
    lambdas = collect(360.0:10.0:830.0)
    col=cmf(CMF31)
    #hold(false)
    #fig = gcf()
    x=zeros(length(lambdas))
    y=zeros(length(lambdas))
    z=zeros(length(lambdas))
    @inbounds for w in 0.1:10.0:400.1
        @inbounds for i in 1:length(lambdas)
            ill=led_spec(360.0,830.0,1.0,lambdas[i],w)
            color = convert(xyY,ill*col)
            x[i] = color.x
            y[i] = color.y
            z[i] = color.Y
            #color = convert(DIN99o,ill*col)
            #x[i] = color.a
            #y[i] = color.b
            #z[i] = color.l

        end
        #plot3!(fig,x,y,z,":b")
        #wireframe!(fig,x, y, z)
        #hold(true)
    end
    #aspectratio(1.0)
    #viewpoint(30, -20)
    #fig
    #videofile("rotationtestYxy.mp4") do
    #    for rot = -90:1:90
    #        viewpoint(rot, 45)
    #        draw(fig)
    #    end
    #    for rot = 89:-1:-89
    #        viewpoint(rot,45)
    #        draw(fig)
    #    end
    #end
end