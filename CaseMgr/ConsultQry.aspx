﻿<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="ConsultQry.aspx.cs" Inherits="CaseMgr_ConsultQry" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../include/main.css" rel="stylesheet" type="text/css" />
    <link href="../include/table.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../include/jquery-1.7.js"></script>
    <link rel="stylesheet" type="text/css" href="../include/calendar-win2k-cold-1.css" />
    <script type="text/javascript" src="../include/calendar.js"></script>
    <script type="text/javascript" src="../include/calendar-big5.js"></script>
    <script type="text/javascript" src="../include/common.js"></script>
    <%--<script type="text/javascript" src="../include/HFPChurch.js"></script>--%>
    <script type="text/javascript" src="../include/jquery.metadata.min.js"></script>
    <script type="text/javascript" src="../include/jquery.field.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            InitAjaxLoading();
            //-----------------------------------------------------------------------
            // menu控制
            InitMenu();
            //-----------------------------------------------------------------------
            //初始化日曆
            //initCalendar(['StartDate', 'EndDate']);
            //-----------------------------------------------------------------------
            BindNumeric();

            $("#ddlCity").bind("change", function (e) {
                ChangeArea(e, 'ddlArea');
            });

        
            $("#ddlArea").bind("change", function (e) {
                var ZipCode = $(this).val();
                if (ZipCode != '0') {
                    $('#txtZipCode').val(ZipCode);
                    $('#HFD_Area').val(ZipCode);
                }
            });
            loadHfdData();

            //婚姻狀況
            $('input:checkbox[id*=CHK_Marry]').bind("click", function (e) {
                var ret = '';
                $('input:checkbox:checked[name="Marry"]').each(function (i) { ret += this.value + ','; });
                $('#HFD_Marry').val(ret);
            });

            //來電諮詢別(分項)
            $('input:checkbox[id*=CHK_ConsultantItem]').bind("click", function (e) {
                var ret = '';
                $('input:checkbox:checked[name="ConsultantItem"]').each(function (i) { ret += this.value + ','; });
                $('#HFD_ConsultantItem').val(ret);
            });
           
        }); //end of ready()
       
      


        function loadHfdData() {

            if ($('#HFD_Area').val() != '') {
                var CityID = $('#ddlCity').val();
                $.ajax({
                    type: 'post',
                    url: "../common/ajax.aspx",
                    data: 'Type=GetAreaList' + '&CityID=' + CityID,
                    success: function (result) {
                        $('select[id$=ddlArea]').html(result);
                        $("#ddlArea").val($('#HFD_Area').val());
                    },
                    error: function () { alert('ajax failed'); }
                })
            }
        }

    </script>
    <script type="text/javascript">
        //-------------
        function LoadConsultQry(tType) {
            $.ajax({
                type: 'post',
                url: "../common/ajax.aspx",
                data: 'Type=LoadConsultQry' + '&tType=' + tType
                        + '&Event=' + $('#txtEvent').val()
                        + '&Phone=' + $('#txtPhone').val()
                        + '&CName=' + $('#txtName').val()
                        + '&Marry=' + $('#HFD_Marry').val()
                        + '&BegCreateDate=' + $('#txtBegCreateDate').val()
                        + '&EndCreateDate=' + $('#txtEndCreateDate').val()
                        + '&City=' + $('#ddlCity').val()
                        + '&ZipCode=' + $('#txtZipCode').val()
                        + '&Address=' + $('#txtAddress').val()
                        + '&ServiceUser=' + $('#txtServiceUser').val()
                        + '&EditServiceUser=' + $('#HFD_EditServiceUser').val()
                        + '&ConsultantItem=' + $('#HFD_ConsultantItem').val(),
                async: false,
                success: function (result) {

                    $('#lblGridList').html(result);
                    // alert("完成!");
                    //                  
                },
                error: function () { alert('ajax failed'); }
            })
        }
        //***************

    </script>
                      
                

     <script type="text/javascript">

         
         function ChangeArea(e, NoticeArea) {
             var CityID = $(e.target).val();
             $.ajax({
                 type: 'post',
                 url: "../common/ajax.aspx",
                 data: 'Type=GetAreaList' + '&CityID=' + CityID,
                 success: function (result) {
                     $('select[id$=' + NoticeArea + ']').html(result);
                     $('#HFD_ZipCode').val('');
                     var a = $('#txtZipCode').val();
                     $('#txtZipCode').val('');
                 },
                 error: function () { alert('ajax failed'); }
             })
         }

         window.onload = initCalendar;
         function initCalendar() {
             Calendar.setup({
                 inputField: "txtBegCreateDate",   // id of the input field
                 button: "imgBegCreateDate"     // 與觸發動作的物件ID相同
                
             });
             Calendar.setup({
                
                 inputField: "txtEndCreateDate",   // id of the input field
                 button: "imgEndCreateDate"     // 與觸發動作的物件ID相同
             });
             Calendar.showYearsCombo(true);
         }
          
    </script>

   
</head>
<body class="body" >
    <form id="Form1" runat="server" >
     <asp:HiddenField ID="HFD_MemberID" runat="server" />
    <asp:HiddenField ID ="HFD_LoadFormData" runat ="server" />
    <asp:HiddenField ID ="HFD_Area" runat="server" />
    <asp:HiddenField ID ="HFD_SQL" runat="server" />
    <asp:HiddenField ID="HFD_ConsultantItem" runat="server" />
    <asp:HiddenField ID="HFD_EditServiceUser" runat="server" />
    <asp:HiddenField ID="HFD_Marry" runat="server" />

    <div id="menucontrol">
        <a href="#"><img id="menu_hide" alt="" src="../images/menu_hide.gif" width="15" height="60" onclick="SwitchMenu();return false;" /></a>
        <a href="#"><img id="menu_show" alt="" src="../images/menu_show.gif" width="15" height="60" onclick="SwitchMenu();return false;" /></a>
    </div>
    <asp:Label runat="server" ID="Toolbar"></asp:Label>
    <h1>
        <img src="../images/h1_arr.gif" alt="" width="10" height="10" />
        <asp:Literal ID="litTitle" runat="server" Text="查詢作業"></asp:Literal>
    </h1>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="1" class="table_v">
        <tr>
            <td width="100%" colspan="10">
                <asp:Literal runat="server" ID="MainMenu"></asp:Literal>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="1" class="table_v">
        <tr>
        <th align="right">
           姓名：
            </th>
            <td>
                <asp:TextBox ID="txtName" runat="server"></asp:TextBox>
            </td>
         
            <th align="right">
               電話：
            </th>
            <td>
                <asp:TextBox ID="txtPhone" runat="server"></asp:TextBox>
            </td>
            
            
              <th align="right">
                建檔時間：
            </th>
            <td>
                <asp:TextBox ID="txtBegCreateDate" CssClass="font9" Width="28mm" runat="server" onchange="CheckDateFormat(this, '日期');"></asp:TextBox>
                <img id="imgBegCreateDate" alt="" src="../images/date.gif" />
                <asp:TextBox ID="txtEndCreateDate" CssClass="font9" Width="28mm" runat="server" onchange="CheckDateFormat(this, '日期');"></asp:TextBox>
                <img id="imgEndCreateDate" alt="" src="../images/date.gif" />
            </td>
        </tr>
        <tr>
           
            <th align="right" >
                志工：
            </th>
            <td colspan="1">
                <asp:TextBox runat="server" Width="50mm" ID="txtServiceUser"></asp:TextBox>
            </td>
             <th align="right">婚姻：</th>
                            <td  style="width :60mm">
                              <asp:Label ID="lblMarry" runat="server"></asp:Label>
                             
                            </td>
            
             <th align="right" class="weekend">
               事件關鍵字：
            </th>
            <td>
                <asp:TextBox ID="txtEvent" runat="server"></asp:TextBox>
            </td>
                 
        </tr>
         <tr>
                                <th align="left" style ="width:40mm" >
                                來電諮詢別(分項)：
                                </th>
                                <td colspan ="5">
                                   <asp:Label ID="lblConsultantItem" runat="server"></asp:Label>
                                </td>
                            </tr>
        <tr>
           <th align="right">地址：
                            </th>
                            <td  colspan="5">
                            縣市：<asp:DropDownList ID="ddlCity" runat="server" ></asp:DropDownList>
                                區鄉鎮：<asp:DropDownList ID="ddlArea" runat="server" ></asp:DropDownList>
                                郵遞區號：<asp:TextBox runat="server" ID="txtZipCode" Width="20mm" MaxLength="5"></asp:TextBox>
                                地址：<asp:TextBox ID="txtAddress" Width="60mm" runat="server"></asp:TextBox>
                            </td>  
                         
                            
        </tr>
        <tr>
            <th align="right">
                是否為基督徒：
            </th>
            <td align="left" colspan="5">
                 <asp:RadioButtonList ID="rblChristian" runat="server" 
                    RepeatDirection="Horizontal">
                    <asp:ListItem Value="1">是</asp:ListItem>
                    <asp:ListItem Value="2">否</asp:ListItem>
                    <asp:ListItem Value="3" Selected="True">全部</asp:ListItem>
                </asp:RadioButtonList>
            </td> 
        </tr>
        <tr>
              <td align ="right" colspan="6">
                 <asp:Button ID="btnQuery" class="npoButton npoButton_Search" runat="server"  
                    Text="查詢" OnClick="btnQuery_Click"/>
            </td>
        </tr>
        <tr>
            <td width="80%" colspan="6">
                <asp:Label ID="lblGridList" runat="server"></asp:Label>
                <asp:Label ID="lblReport" runat="server"  Visible="false"></asp:Label>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
