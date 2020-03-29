using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using ataweb.Models;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace ataweb.Controllers
{
    public class LoginController : Controller
    {

        public IActionResult Index()
        {
            ClaimsPrincipal principal = HttpContext.User as ClaimsPrincipal;
            if (principal != null)
                if (principal.Claims.Count() != 0) return RedirectToAction("Index", "Home");

            //Dictionary<string, string> dict = new Dictionary<string, string>();

            //var listClaims  = HttpContext.User.Claims.ToList();
            //foreach (var item in listClaims)
            //{
            //    dict.Add(item.Type, item.Value);
            //}
            //Auth json = JsonConvert.DeserializeObject<Auth>(JsonConvert.SerializeObject(dict));

            return View();
        }
        [HttpPost]
        public async Task<IActionResult> SignIn(String jsonUser)
        {
            string loginUrl = $"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={Auth.api}";
            HttpClient client = new HttpClient();
            HttpContent content = new StringContent(jsonUser);
            try
            {
                var authRespone = await client.PostAsync(loginUrl, content);
                string authJsonString = await authRespone.Content.ReadAsStringAsync();
                Auth auth = JsonConvert.DeserializeObject<Auth>(authJsonString);
                if (auth.error != null) return Content("{\"success\":false,\"data\":\"" + auth.error["message"] + "\"}");

                var authClaim = new List<Claim>() {
                    new Claim("localId",auth.localId),
                    new Claim("email",auth.email),
                    new Claim("idToken",auth.idToken),
                    new Claim("refreshToken",auth.refreshToken),
                };
                var authIndentity = new ClaimsIdentity(authClaim, "UserIdentity");
                var userPrincipal = new ClaimsPrincipal(authIndentity);
                await HttpContext.SignInAsync(userPrincipal);
                return Content("{\"success\":true,\"data\":\"/Home\"}"); ;
            }
            catch (Exception error)
            {
                throw error;
            }
        }
    }
}
