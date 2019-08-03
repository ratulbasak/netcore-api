using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using netcore_api.Controllers;

namespace Api.Test
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void TestMethod1()
        {
            var controller = new ValuesController();
            var res = controller.Get(1);
            Assert.AreEqual(res.Value, "Saturday");
            Console.Write("Lalu");
        }
    }
}
