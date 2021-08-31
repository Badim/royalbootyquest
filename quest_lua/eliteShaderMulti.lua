local kernel = {};
kernel.language = "glsl";
kernel.category = "filter";
kernel.name = "eliteMulti";
kernel.graph =
{
   nodes = {
      hue = { effect="filter.hue", input1="paint1" },
	  saturate = { effect="filter.saturate", input1="hue" },
	  brightness = { effect="filter.brightness", input1="saturate" },
   },
   output = "brightness",
};
return kernel