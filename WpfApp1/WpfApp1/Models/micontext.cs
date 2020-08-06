using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace WpfApp1.Models
{
    public partial class micontext : DbContext
    {
        public micontext()
        {
        }

        public micontext(DbContextOptions<micontext> options)
            : base(options)
        {
        }

        public virtual DbSet<Tipomovi> Tipomovi { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                string connection = System.Configuration.ConfigurationManager.ConnectionStrings["conexion"].ConnectionString;
                optionsBuilder.UseSqlServer(connection);
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Tipomovi>(entity =>
            {
                entity.HasNoKey();

                entity.ToTable("TIPOMOVI");

                entity.Property(e => e.Cdtipomov)
                    .IsRequired()
                    .HasColumnName("CDTIPOMOV")
                    .HasMaxLength(5)
                    .IsUnicode(false)
                    .IsFixedLength();

                entity.Property(e => e.Cdtipopre)
                    .HasColumnName("CDTIPOPRE")
                    .HasMaxLength(3)
                    .IsUnicode(false)
                    .IsFixedLength();

                entity.Property(e => e.Correlativo)
                    .HasColumnName("CORRELATIVO")
                    .HasColumnType("numeric(10, 0)");

                entity.Property(e => e.Ctoprom).HasColumnName("CTOPROM");

                entity.Property(e => e.Dsabrev)
                    .HasColumnName("DSABREV")
                    .HasMaxLength(10)
                    .IsUnicode(false)
                    .IsFixedLength();

                entity.Property(e => e.Dstipomov)
                    .IsRequired()
                    .HasColumnName("DSTIPOMOV")
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.Inout).HasColumnName("INOUT");

                entity.Property(e => e.Pagocred).HasColumnName("PAGOCRED");

                entity.Property(e => e.Percont).HasColumnName("PERCONT");

                entity.Property(e => e.Provee).HasColumnName("PROVEE");

                entity.Property(e => e.Tipoper)
                    .HasColumnName("TIPOPER")
                    .HasMaxLength(5)
                    .IsUnicode(false)
                    .IsFixedLength();

                entity.Property(e => e.Tstamp)
                    .IsRequired()
                    .HasColumnName("TSTAMP")
                    .IsRowVersion()
                    .IsConcurrencyToken();

                entity.Property(e => e.Usumult)
                    .HasColumnName("USUMULT")
                    .HasColumnType("numeric(18, 0)");

                entity.Property(e => e.Valcospre).HasColumnName("VALCOSPRE");

                entity.Property(e => e.Valor).HasColumnName("VALOR");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
