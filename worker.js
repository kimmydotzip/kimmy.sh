addEventListener("fetch", event => {
  event.respondWith(handleRequest(event.request));
});

async function handleRequest(request) {
  const userAgent = request.headers.get("User-Agent") || "";

  if (userAgent.toLowerCase().includes("curl")) {
    // Simply forward the request to the Cloudflare Pages backend
    return fetch(request);
  } else {
    // Redirect browsers to https://kimmy.sh/access
    return Response.redirect("https://kimmy.sh/access", 302);
  }
}
