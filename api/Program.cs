using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;

namespace netcore_api
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateWebHostBuilder(args)
	        .UseUrls("http://0.0.0.0:5000/")
	        .Build()
            .Run();
        }

        public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
                .UseStartup<Startup>();
    }
}
