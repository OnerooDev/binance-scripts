import json
import os
import subprocess

ADDRESS2PRJ = {
      "MULTICALL": "multicall",
      "FAUCET": "token-faucet",
      "MCD_DEPLOY": "dss-deploy",
      "MCD_GOV": "ds-token",
      "GOV_GUARD": "mkr-authority",
      "MCD_ADM": "ds-roles",
      "MCD_VAT": "dss-deploy",
      "MCD_JUG": "dss-deploy",
      "MCD_CAT": "dss-deploy",
      "MCD_VOW": "dss-deploy",
      "MCD_JOIN_DAI": "dss-deploy",
      "MCD_FLAP": "dss-deploy",
      "MCD_FLOP": "dss-deploy",
      "MCD_PAUSE": "dss-deploy",
      "MCD_PAUSE_PROXY": "dss-deploy",
      "MCD_GOV_ACTIONS": "dss-deploy",
      "MCD_DAI": "dss-deploy",
      "MCD_SPOT": "dss-deploy",
      "MCD_POT": "dss-deploy",
      "MCD_END": "dss-deploy",
      "MCD_ESM": "dss-deploy",
      "PROXY_ACTIONS": "dss-proxy-actions",
      "PROXY_ACTIONS_END": "dss-proxy-actions",
      "PROXY_ACTIONS_DSR": "dss-proxy-actions",
      "CDP_MANAGER": "dss-cdp-manager",
      "DSR_MANAGER": "dsr-manager",
      "GET_CDPS": "dss-cdp-manager",
      "ILK_REGISTRY": "ilk-registry",
      "OSM_MOM": "osm-mom",
      "FLIPPER_MOM": "flipper-mom",
      "PROXY_FACTORY": "ds-proxy",
      "PROXY_REGISTRY": "proxy-registry",
      "VOTE_PROXY_FACTORY": "vote-proxy",
      "ETH": "ds-weth",
      "PIP_ETH": "ds-value",
      "MCD_JOIN_ETH_A": "dss-deploy",
      "MCD_FLIP_ETH_A": "dss-deploy",
      "BAT": "dss-deploy",
      "PIP_BAT": "ds-value",
      "MCD_JOIN_BAT_A": "dss-deploy",
      "MCD_FLIP_BAT_A": "dss-deploy",
      "USDC": "dss-deploy",
      "PIP_USDC": "ds-value",
      "MCD_JOIN_USDC_A": "dss-deploy",
      "MCD_FLIP_USDC_A": "dss-deploy",
      "MCD_JOIN_USDC_B": "dss-deploy",
      "MCD_FLIP_USDC_B": "dss-deploy",
      "WBTC": "dss-deploy",
      "PIP_WBTC": "ds-value",
      "MCD_JOIN_WBTC_A": "dss-deploy",
      "MCD_FLIP_WBTC_A": "dss-deploy",
      "TUSD": "dss-deploy",
      "PIP_TUSD": "ds-value",
      "MCD_JOIN_TUSD_A": "dss-deploy",
      "MCD_FLIP_TUSD_A": "dss-deploy",
      "ZRX": "dss-deploy",
      "PIP_ZRX": "ds-value",
      "MCD_FLIP_ZRX_A": "dss-deploy",
      "MCD_JOIN_ZRX_A": "dss-deploy",
      "KNC": "dss-deploy",
      "PIP_KNC": "ds-value",
      "MCD_FLIP_KNC_A": "dss-deploy",
      "MCD_JOIN_KNC_A": "dss-deploy",
      "MANA": "dss-deploy",
      "PIP_MANA": "ds-value",
      "MCD_FLIP_MANA_A": "dss-deploy",
      "MCD_JOIN_MANA_A": "dss-deploy",
      "USDT": "dss-deploy",
      "PIP_USDT": "ds-value",
      "MCD_JOIN_USDT_A": "dss-deploy",
      "MCD_FLIP_USDT_A": "dss-deploy",
      "PAXUSD": "dss-deploy",
      "PIP_PAXUSD": "ds-value",
      "MCD_JOIN_PAXUSD_A": "dss-deploy",
      "MCD_FLIP_PAXUSD_A": "dss-deploy",
      "PROXY_PAUSE_ACTIONS": "dss-deploy-pause-proxy-actions",
      "PROXY_DEPLOYER": "proxy-registry"
    }



def get(v):
    # cmd = "wget https://changelog.makerdao.com/releases/mainnet/%s/contracts.json -O contracts.%s.json"%(v, v)
    # os.system(cmd)

    with open("contracts.%s.json"%v) as json_file:
        return json.load(json_file)


def calcBreakVersions():
    vv = ["1.1.1", "1.1.0", "1.0.9", "1.0.8", "1.0.7", "1.0.6", "1.0.5", "1.0.4", "1.0.3", "1.0.2", "1.0.1", "1.0.0"]

    contracts = []
    for v in vv:
        contracts.append(get(v))


    keys = list(contracts[0].keys())

    breakVersions = {}

    for k in keys:
        # print("")
        # print(k)
        lastAddr = None
        breakVer = None
        for i in range(len(contracts)):
            c = contracts[i]
            addr = c.get(k)
            if addr is None:
                if breakVer is None:
                    breakVer = vv[i-1]
                # print(vv[i], addr, breakVer)
                continue

            if lastAddr is None:
                lastAddr = addr
            if breakVer is None and lastAddr.upper() != addr.upper():
                breakVer = vv[i-1]

            # print(vv[i], addr, breakVer)

        if breakVer is None:
            breakVer = vv[len(vv)-1]
        breakVersions[k] = (breakVer, lastAddr)
        print(k, breakVer, lastAddr)
    return breakVersions

def getRevisions(srcdir="contracts"):
    baseDir = os.getcwd()
    cbv = calcBreakVersions()

    os.chdir(srcdir)
    rootdir = os.getcwd()

    res = {}

    for k, (ver, addr) in cbv.items():
        prj = ADDRESS2PRJ[k]
        # print()
        os.chdir(os.path.join(rootdir, prj))

        for vformat in ["%s", "v.%s"]:
            fver = vformat%ver
            cmd = "git show refs/tags/%s -s --format=%%H"%fver
            try:
                result = subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True).decode('ascii').rstrip()
                break
            except subprocess.CalledProcessError as ex:
                print("git call failed")
                result = None

        print(rootdir, k, prj, ver, addr, result)

        isMaster = False
        if result is None:
            try:
                cmd = "git show refs/remotes/origin/master -s --format=%H"
                result = subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True).decode('ascii').rstrip()
                isMaster = True
            except subprocess.CalledProcessError as ex:
                # print("git call failed")
                result = None

        # print(k, prj, ver, result, res.get(prj))
        # if res.get(prj) is not None and res.get(prj) != result:
        #     raise RuntimeError( "inconsistent rev " + prj + " " + k)
        if res.get(prj) is None:
            res[prj] = []
        res[prj].append(dict(ver=ver, contract=k, rev=result, master=isMaster, address=addr))

    os.chdir(baseDir)
    return res

def selectRevision(revisions):
    res = {}

    for prj, data in revisions.items():
        data.sort(key=lambda o: o["ver"], reverse=True)
        res[prj] = data[0]
    return res

def switchPrjs(srcdir="contracts"):
    with open(".dapp.bak.json") as json_file:
        dappsCfg = json.load(json_file)

    revisions = selectRevision(getRevisions(srcdir))

    contracts = dappsCfg["contracts"]
    for key, project in contracts.items():
        rev = revisions.get(project["name"])
        if rev is not None:
            rev = rev.get("rev")
        else:
            print(key, project["name"], "-----BAD REV")

        oldRev = project["repo"]["rev"]
        print(key, project["name"], oldRev, "->", rev)
        if rev is not None:
            project["repo"]["rev"] = rev


    with open(".dapp.new.json", 'w') as file:
        file.write(json.dumps(dappsCfg, sort_keys=True, indent=4))





if __name__ == '__main__':
    # print(json.dumps(calcBreakVersions()))
    print(json.dumps(getRevisions(), sort_keys=True, indent=4))
    # print(json.dumps(selectRevision(getRevisions()), sort_keys=True, indent=4))
    # switchPrjs()

