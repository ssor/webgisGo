
<div class="toolbar-top">
  <div class="toolbar-inner">
    <div class="links-left"><a href="/mobile" class="back" onclick = "goback()"><i class="icon-back-blue"></i><span>Back</span></a></div>
    <h1 class="sliding"><%= carID %></h1>
    <div class="links-right"><a href="#" class="open-panel"><i class="icon-bars-blue"></i></a></div>
  </div>
</div>
<div class="pages toolbar-top-through toolbar-bottom-through">
  <div data-page="forms" class="page">
    <div class="page-content">
<!--       <div class="content-block">
        <p>Framework7 provides very flexible forms layout</p>
      </div>
 -->      <div class="list-panel">
        <div class="content-block-title">上传经纬度到服务器</div>
        <ul>
          <li>
            <div class="inner">
              <div class="text label">经度</div>
              <div class="input">
                <input type="text" placeholder="0.0" id="inputLongitude" />
              </div>
            </div>
          </li>
          <li>
            <div class="inner">
              <div class="text label">纬度</div>
              <div class="input">
                <input type="text" placeholder="0.0"  id="inputLatitude" />
              </div>
            </div>
          </li>
 
        </ul>
      </div>
      <div class="content-block">
        <p  id = "lblTime">上传时间：尚未开始</p>
        <p id = "lblTip"></p>
      </div>

      <div class="content-block">
        <!-- <div class="content-block-title">Buttons</div> -->
        <div class="grid-1">
          <!-- <div class="col"><a href="#" class="button active">Active</a></div> -->
          <div class="col"><a href="#" class="button" onclick="">首页</a></div>
          <!-- <div class="col"><a href="#" class="button round">Round</a></div> -->
        </div>
      </div>
    </div>
  </div>
</div>