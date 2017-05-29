/** Ti.admob original attribution
* Copyright (c) 2011 by Studio Classics. All Rights Reserved.
* Author: Brian Kurzius
* Licensed under the terms of the Apache Public License
* Please see the LICENSE included with this distribution for details.
*/

package ti.admobint;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.TiLifecycle.OnLifecycleEvent;
import org.appcelerator.titanium.proxy.TiViewProxy;
import org.appcelerator.titanium.TiBaseActivity;
import org.appcelerator.kroll.common.Log;
import org.appcelerator.titanium.view.TiUIView;

import android.app.Activity;

@Kroll.proxy(creatableInModule = AdmobintModule.class)
public class BannerViewProxy extends TiViewProxy implements OnLifecycleEvent {
  private BannerView adMob;
  private static final String TAG = "AdMobIntBannerViewProxy";

  public BannerViewProxy() {
    super();
  }

  @Override
  protected KrollDict getLangConversionTable() {
    KrollDict table = new KrollDict();
    table.put("title", "titleid");
    return table;
  }

  @Override
  public TiUIView createView(Activity activity) {
    adMob = new BannerView(this);
    ((TiBaseActivity)activity).addOnLifecycleEventListener(this);
    return adMob;
  }

  @Override
  public void onDestroy(Activity activity) {
    adMob.destroy();
  }

  @Override
  public void onPause(Activity activity) {
    adMob.pause();
  }

  @Override
  public void onResume(Activity activity) {
    adMob.resume();
  }

  @Override
  public void onStart(Activity activity) {
  }

  @Override
  public void onStop(Activity activity) {
  }

  @Kroll.method
  public void loadAd(KrollDict d) {
    adMob.loadAd(d);
  }
}
