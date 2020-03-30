using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ataweb.Models
{
    public class Auth
    {
        public static string api = "AIzaSyCfrk-pANuYEeE3Npr87FEyyk8TwH6jJ5s";
        public string localId { get; set; }
        public string email { get; set; }
        public string idToken { get; set; }
        public string refreshToken { get; set; }
        public Dictionary<string, dynamic> error { get; set; }
    }
}
