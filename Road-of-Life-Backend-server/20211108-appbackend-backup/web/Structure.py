class NodeEdgeInfo:
    def __init__(self):
        self.sourceNodes = list()
        self.targetNodes = list()
        self.sourceNodesAmounts = dict()
        self.targetNodesAmounts = dict()

class NodeInfo:
    def __init__(self):
        self.piv = 0
        self.pov = 0
        self.entropy = 0