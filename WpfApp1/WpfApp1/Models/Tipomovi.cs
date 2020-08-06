using System;
using System.Collections.Generic;

namespace WpfApp1.Models
{
    public partial class Tipomovi
    {
        public string Cdtipomov { get; set; }
        public string Dstipomov { get; set; }
        public string Dsabrev { get; set; }
        public bool Inout { get; set; }
        public bool Provee { get; set; }
        public bool Valor { get; set; }
        public bool Valcospre { get; set; }
        public bool Ctoprom { get; set; }
        public string Cdtipopre { get; set; }
        public byte[] Tstamp { get; set; }
        public decimal? Correlativo { get; set; }
        public decimal? Usumult { get; set; }
        public bool Pagocred { get; set; }
        public bool? Percont { get; set; }
        public string Tipoper { get; set; }
    }
}
