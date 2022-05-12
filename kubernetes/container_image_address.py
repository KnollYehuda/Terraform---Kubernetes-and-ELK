import sys

address = {
    "af-south-1": "877085696533",
    "ap-east-1": "800184023465",
    "ap-northeast-1": "602401143452",
    "ap-northeast-2": "602401143452",
    "ap-northeast-3": "602401143452",
    "ap-south-1": "602401143452",
    "ap-southeast-1": "602401143452",
    "ap-southeast-2": "602401143452",
    "ca-central-1": "602401143452",
    "cn-north-1": "918309763551",
    "cn-northwest-1": "961992271922",
    "eu-central-1": "602401143452",
    "eu-north-1": "602401143452",
    "eu-south-1": "590381155156",
    "eu-west-1": "602401143452",
    "eu-west-2": "602401143452",
    "eu-west-3": "602401143452",
    "me-south-1": "558608220178",
    "sa-east-1": "602401143452",
    "us-east-1": "602401143452",
    "us-east-2": "602401143452",
    "us-gov-east-1": "151742754352",
    "us-gov-west-1": "013241004608",
    "us-west-1": "602401143452",
    "us-west-2": "602401143452"
}

if __name__ == '__main__':
    try:
        print(address[sys.argv[1]])
    except Exception as ex:
        print(address['eu-west-2'])
