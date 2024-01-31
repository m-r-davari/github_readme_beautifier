'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "53716e521a2c0441bc67b5f11172b7e4",
"coi-serviceworker.min.js": "7257e40445f71916db5acd8c6f6fba40",
"index.html": "bcc8d45b657ae2fd663538dcebdfed3e",
"/": "bcc8d45b657ae2fd663538dcebdfed3e",
"main.dart.js": "a270f49fb81f70ad2765145f878bd1b8",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"coi-serviceworker.js": "a4daccd63324b6b58456ad52c8cbba15",
"manifest.json": "a5cbfb108cc49d79ba4f624ed5146080",
"firebase.json": "0b984b1a93fd244df237dd49ea758d2b",
"assets/AssetManifest.json": "5af489d4d8ede29f34e9c206218e7376",
"assets/NOTICES": "ff9e8c34fde4754adb50d8630806f20e",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "934413d334640a8375ee09ba02e5d29c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/packages/flutter_3d_controller/assets/model-viewer.min.js": "4226392bee9372f20a688343e51e7b54",
"assets/packages/flutter_3d_controller/assets/template.html": "8de94ff19fee64be3edffddb412ab63c",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"assets/AssetManifest.bin": "83348db011468767d35246b6b72e9f4f",
"assets/fonts/MaterialIcons-Regular.otf": "89278a0afa129a6b9daad05dc9459a8e",
"assets/assets/mr_github_friends_light.gif": "d6adcb05e016218e1bbb29d2f542efd9",
"assets/assets/mr_most_langs_dark.gif": "aebc14da0b4ad5ec3873a3840d83fdd0",
"assets/assets/github_meme_thumbnail.gif": "0ebecec086987ec830beffc96b6c3a24",
"assets/assets/mr_typewriter_text_light_loop.gif": "be17d630b51f99444223cbc2b64467dd",
"assets/assets/mr_typewriter_text_dark_loop.gif": "fc9e25923137bce277162aa6839a9b6d",
"assets/assets/mr_github_meme_light.gif": "8aa0bfac293e5df70e659a9964a0b74c",
"assets/assets/typewriter_text_light.gif": "755f12ea0baa77a9d683ac91c165be82",
"assets/assets/repos_languages_overview_thumbnail.gif": "795f3c477b983bafd28be45daad1750e",
"assets/assets/u3f_most_langs_dark.gif": "b6649615e032f7b5722b7d0419c56136",
"assets/assets/github_loading.gif": "c502cd01c910b4f53d86603d6bd078ff",
"assets/assets/logo_github_1.png": "b3cc5ce579c1f5a3139ded55fb7d2726",
"assets/assets/mr_most_langs_light.gif": "a1d6364329317cc54c2063f4b171b330",
"assets/assets/typewriter_text_dark.gif": "5252b73c5ba0c962781706725ba4b21d",
"assets/assets/u3f_most_langs_light.gif": "2f43301d7af4ed31e4aedc33d2f110e2",
"assets/assets/github_meme_dark.gif": "040ddc0844e7595670378b9046885d8a",
"assets/assets/mr_github_meme_dark.gif": "0c49c20a1354614e1bdc4cf7a07672ba",
"assets/assets/mr_langs_overview_dark.gif": "29957fcf13a7bef68ce848c719db3364",
"assets/assets/colorful_typewriter_text_dark_noloop.gif": "6a73a02d6bb78f8cbe947a3eeb5af28a",
"assets/assets/colorful_typewriter_text_light_noloop.gif": "252f014e0f70260a691d8ac58a24cb9e",
"assets/assets/mr_github_friends_circle_dark.gif": "e1d23b517db0066b0293bbb931d7172f",
"assets/assets/mr_github_friends_circle_light.gif": "31d377e07645a1f3ac6c1232a81b8ada",
"assets/assets/most_used_language_thumbnail.gif": "eb47ab0710d530e8f814c3a6d42db2cc",
"assets/assets/github_friends_thumbnail.gif": "599b067b20ca1d4f87cd5400a9cbfbbe",
"assets/assets/typewriter_text_thumbnail.gif": "c56acb2aa27abcae0081d23fbbceced4",
"assets/assets/github_meme_light.gif": "32d801ac061b81fd372e25e924c167da",
"assets/assets/github_meme_sc.png": "32a983a3f83ebd7de9e41ba69d280ded",
"assets/assets/mr_github_friends_dark.gif": "079953b4274773971b2e01d8bc8410dc",
"assets/assets/mr_langs_overview_light.gif": "e298fe49e51f40c0f08dd49566795fc6",
"assets/assets/hzh_langs_overview_light.gif": "076b499ed61b4a2bc1e6f6be2cc3b15a",
"assets/assets/hzh_langs_overview_dark.gif": "691009c8434bf63a7688da9fa12ad831"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
