for i in range(97,123):
    test_str = list("test")
    for char in chr(i):
        test_str.append(char)
    print(''.join(a for a in test_str))
