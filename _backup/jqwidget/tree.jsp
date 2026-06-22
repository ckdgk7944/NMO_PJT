<%@ page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="keywords" content="jQuery Tree, Tree Widget, TreeView" />
    <meta name="description" content="The jqxTree can easily display images next to each item. In order to achieve that, you need to add 'img' element inside a 'li' element." />
    <title id='Description'>The jqxTree in this demo displays images next to the tree items.
    </title>
    <link rel="stylesheet" href="/xplugin/jqwidgets/styles/jqx.base.css" type="text/css" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta name="viewport" content="width=device-width, initial-scale=1 maximum-scale=1 minimum-scale=1" />
    <script type="text/javascript" src="/xefc/script/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="/xplugin/jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="/xplugin/jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="/xplugin/jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="/xplugin/jqwidgets/jqxpanel.js"></script>
    <script type="text/javascript" src="/xplugin/jqwidgets/jqxtree.js"></script>
    <script type="text/javascript" src="/xplugin/jqwidgets/jqxexpander.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            // Create jqxExpander
            $('#jqxExpander').jqxExpander({ showArrow: false, toggleMode: 'none', width: '300px', height: '400px'});
            // Create jqxTree

            var source = [
            {
                icon: "/images/icon/ic_division.png", label: "Mail", expanded: true, items: [
                  { icon: "/images/icon/ic_name.png", label: "Calendar", value: "Calendar_val" },
                  { icon: "/images/icon/ic_name.png", label: "Contacts", selected: true }
                ]
            },
            {
                icon: "/images/icon/ic_division.png", label: "Inbox", expanded: false, items: [
                 { icon: "/images/icon/ic_name.png", label: "Admin" },
                 { icon: "/images/icon/ic_name.png", label: "Corporate" },
                 { icon: "/images/icon/ic_name.png", label: "Finance" },
                 { icon: "/images/icon/ic_name.png", label: "Other" },
                ]
            },
            {
                icon: "/images/icon/ic_division.png", label: "Inbox", expanded: false, items: [
                 { icon: "/images/icon/ic_name.png", label: "Admin" },
                 { icon: "/images/icon/ic_name.png", label: "Corporate" },
                 { icon: "/images/icon/ic_name.png", label: "Finance" },
                 { icon: "/images/icon/ic_name.png", label: "Other" },
                ]
            },
            { icon: "/images/icon/ic_division.png", label: "Deleted Items" },
            { icon: "/images/icon/ic_division.png", label: "Notes" },
            { iconsize: 14, icon: "/images/icon/ic_division.png", label: "Settings" },
            { icon: "/images/icon/ic_division.png", label: "Favorites" }
            ];
            $('#jqxTree').jqxTree({ source: source, width: '100%', height: '100%'});
            //$('#jqxTree').jqxTree('selectItem', null);


            $('#Events').jqxPanel({  height: '250px', width: '200px' });
            $('#Events').css('border', 'none');
            // on to 'expand', 'collapse' and 'select' events.
            $('#jqxTree').on('expand', function (event) {
                var args = event.args;
                var item = $('#jqxTree').jqxTree('getItem', args.element);
                $('#Events').jqxPanel('prepend', '<div style="margin-top: 5px;">Expanded: ' + item.label + '</div>');
            });
            $('#jqxTree').on('collapse', function (event) {
                var args = event.args;
                var item = $('#jqxTree').jqxTree('getItem', args.element);
                $('#Events').jqxPanel('prepend', '<div style="margin-top: 5px;">Collapsed: ' + item.label + '</div>');
            });
            $('#jqxTree').on('select', function (event) {
                var args = event.args;
                var item = $('#jqxTree').jqxTree('getItem', args.element);
                if(!item.hasItems){
                	$('#Events').jqxPanel('prepend', '<div style="margin-top: 5px;">Selected: ' + item.text  + '</div>');
                }
            });
        });
    </script>
</head>
<body class='default'>
    <div id='jqxWidget'>
        <div id='jqxExpander'>
            <div>사용자정보</div>
            <div style="overflow: hidden;">
                <div style="border: none;" id='jqxTree'>
                </div>
            </div>
        </div>
    </div>
            <div style='margin-left: 20px; float: left;'>
                <div>
                    <span>
                        Events:</span>
                    <div id='Events'>
                    </div>
                </div>
            </div>
</body>
</html>