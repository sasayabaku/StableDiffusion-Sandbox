import os
import requests
import json
from tqdm import tqdm
from urllib.parse import urlparse

def download(url: str, local_path: str, chunk_size=1024, progress=False):
    resp = requests.get(url, stream=True)
    total = int(resp.headers.get('content-length', 0))

    if (progress):
        with open(local_path, 'wb') as f, tqdm(
            desc=local_path,
            total=total,
            unit='iB',
            unit_scale=True,
            unit_divisor=1024
        ) as bar:
            for data in resp.iter_content(chunk_size=chunk_size):
                size = f.write(data)
                bar.update(size)

    else:
        print("Downloading {0} ...".format(os.path.basename(local_path)))
        with open(local_path, 'wb') as f:
            for data in resp.iter_content(chunk_size=chunk_size):
                size = f.write(data)

if __name__ == "__main__":

    with open('/workspace/src/models.json', 'r') as j:
        download_list = json.load(j)

    for i, item in enumerate(download_list['models']):

        if(item['name']):
            filename = item['name']
        else:
            url_parse = urlparse(item['url'])
            filename = os.path.basename(url_parse.path)

        save_path = "/workspace/stable-diffusion-webui/models/Stable-diffusion/" + str(filename)

        if(item['minimum'] and not os.path.isfile(save_path)):
            download(item['url'], save_path)

    print("SetUp finished !")
