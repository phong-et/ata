using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace ataweb.Migrations
{
    public partial class AddAttendanceRecordTodb : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AttendanceRecord",
                columns: table => new
                {
                    id = table.Column<int>(nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    localId = table.Column<string>(nullable: false),
                    checkInTime = table.Column<DateTime>(nullable: false),
                    checkOutTime = table.Column<DateTime>(nullable: true),
                    lateReason = table.Column<string>(nullable: true),
                    earlyReason = table.Column<string>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AttendanceRecord", x => x.id);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AttendanceRecord");
        }
    }
}
