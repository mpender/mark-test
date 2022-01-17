# Notes for Review 
Dockerfile 
1. The image is using ubuntu which at the time was ~70MB which could be futher optimized using something like gcr distroless or alpine but there were a few compilation issues with running the x86 binary which I didnt want to get to bogged down on. The final size was ~ 170 which includes the 72MB untarr'd package of litecoind. The final total size was 170MB

2. Here is where I would add relevant build tags, date-time tags or any other key:value parameters required 

3. I used a default working dir so I know where everything is. You can use anything really but I didnt want to add more overhead for this example.

4. This is the meat of the container. 
There is always a risk with doing this many lines within the one RUN statement but the pursuit of sheer image size is important and these build processess are intended to be able to be re-run and have the same outcome. For my testing I have been using --no-cache to ensure a clean build can work. GPG keyserver imports were giving reliability issues so I might have insourced this package validation step instead of reaching out externally each time as its fraught with other issues. 

5. U