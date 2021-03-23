import json
import os
from multiprocessing import Pool
from itertools import repeat


def build(name, solcVer, flags=None):

    os.chdir(name)

    cmd = "dapp --use solc:%s build --extract"%solcVer
    if flags is not None:
        os.putenv("SOLC_FLAGS", flags)
    ret = os.system(cmd)

    print(name, ret, ("build ERROR" if ret != 0 else ""))
    if ret != 0:
        raise RuntimeError(name +" build ERROR - STOP")

def build_mp(it):
    d, rootdir, solcVer, solcVersPerPrj, solcFlagsPerPrj = it
    try:
        build(os.path.join(rootdir, d), solcVer=solcVersPerPrj.get(d, solcVer), flags=solcFlagsPerPrj.get(d))
    except RuntimeError as ex:
        print("EXC", ex)
        return (d, False)
    return (d, True)


def build_all(srcdir="contracts", solcVer="0.5.12", solcVersPerPrj={}, onlyOnePrj=None, solcFlagsPerPrj={}):

    with open(".dapp.json") as json_file:
        dappsCfg = json.load(json_file)


    deps = list(dappsCfg["this"]["deps"].keys())
    print(deps)

    if onlyOnePrj is not None and onlyOnePrj in deps:
        deps = [onlyOnePrj]


    os.chdir(srcdir)
    rootdir = os.getcwd()

    with Pool(4) as p:
        res = p.map(build_mp, zip(deps, repeat(rootdir), repeat(solcVer), repeat(solcVersPerPrj), repeat(solcFlagsPerPrj)))

    for (name, r) in res:
        print(name, r)

    if any(not r[1] for r in res):
        raise RuntimeError("Some errors happen")

    # for d in deps:
    #   os.chdir(rootdir)
    #   build(os.path.join(rootdir, d), solcVer=solcVersPerPrj.get(d, solcVer), solcFlagsPerPrj=solcFlagsPerPrj.get(d))


if __name__ == '__main__':
    solcVer="0.5.12"
    solcVersPerPrj = {"ilk-registry-optimized":"0.6.7", "ilk-registry":"0.6.7", "ds-proxy":"0.4.23", "proxy-registry":"0.4.23",
                      "ds-chief":"0.5.6", "ds-roles":"0.5.6"}

    solcFlagsPerPrj = {"dss-deploy-optimized":"--optimize",
                       "dss-deploy-optimized-11":"--optimize",
                       "freeliquid-ct-optimized":"--optimize",
                       "dss-proxy-actions-optimized":"--optimize",
                       "ilk-registry-optimized":"--optimize --optimize-runs=1000000"}
    onlyOnePrj=None
    # onlyOnePrj="dss-deploy"
    build_all(solcVer=solcVer, solcVersPerPrj=solcVersPerPrj, solcFlagsPerPrj=solcFlagsPerPrj, onlyOnePrj=onlyOnePrj)