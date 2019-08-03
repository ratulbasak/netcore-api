using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;

namespace netcore_api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ValuesController : ControllerBase
    {
        // GET api/values
        [HttpGet]
        public ActionResult<CurrentDateTime> Get()
        {
            return new CurrentDateTime();
        }

        // GET api/values/5
        [HttpGet("{id}")]
        public ActionResult<string> Get(int id)
        {
            return WeekDays.GetDayName(id);
        }
    }

    public static class WeekDays
    {
        private static readonly string[] weekDays = new string[] { "Saturday", "Sunday", "Saturday", "Saturday", "Saturday", "Saturday", "Friday" };

        public static string GetDayName(int dayNumber)
        {
            if (dayNumber > 7 || dayNumber < 1)
            {
                return "No such week day";
            }

            return weekDays[dayNumber - 1];
        }
    }


    public class CurrentDateTime
    {
        private readonly DateTime currentDateTime;
        public CurrentDateTime()
        {
            currentDateTime = DateTime.UtcNow;
        }

        public int Day { get { return currentDateTime.Day; } }
        public int Month { get { return currentDateTime.Month; } }
        public int Year { get { return currentDateTime.Year; } }

        public int Second { get { return currentDateTime.Second; } }

        public int Hour { get { return currentDateTime.Hour; } }

        public int Minute { get { return currentDateTime.Minute; } }

        public string CurrentTime { get { return currentDateTime.ToString(); } }
    }
}
