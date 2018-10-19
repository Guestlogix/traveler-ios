//
//  ViewController.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-09-07.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit
import PassengerKit

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        let groups: [PurchasableGroup] = [
            PurchasableGroup(isFeatured: false, title: "Amsterdam", purchasables: [
                Purchasable(title: "Rijksmuseum", subTitle: "$70", imageURL: URL(string: "https://osmreport.ca/wp-content/uploads/2015/10/lorempixel-3.jpg")),
                Purchasable(title: "Anne Grank House", subTitle: "$50", imageURL: URL(string: "https://osmreport.ca/wp-content/uploads/2015/10/lorempixel-3.jpg")),
                Purchasable(title: "Van Gogh Musuem", subTitle: "$100", imageURL: URL(string: "https://osmreport.ca/wp-content/uploads/2015/10/lorempixel-3.jpg")),
                Purchasable(title: "Dam Swuare", subTitle: "$25", imageURL: URL(string: "https://osmreport.ca/wp-content/uploads/2015/10/lorempixel-3.jpg"))
                ]),
            PurchasableGroup(isFeatured: false, title: "Paris", purchasables: [
                Purchasable(title: "Eiffel Tower", subTitle: "$30", imageURL: URL(string: "https://lh6.googleusercontent.com/proxy/FUMQHsbL2DOVq6QHLV8OKvUj4s7fhsykmcVPBQ3XRwr278O9AHx0ath6sj_MTJ8aOrScbDNnGcUxLpM-aXi8pbiEWt11-b9FYUeYiemLnWXxpl3ZwQ3b_ho0DLxChX9N9N5xEjTFo_nJRswQT9JavVqB1YM=w100-h134-n-k-no")),
                Purchasable(title: "Louvre Museum", subTitle: "$130", imageURL: URL(string: "https://lh4.googleusercontent.com/proxy/Uy7KUiE4yPyd1LFdddov_kyqZ8dzYhsXIDkzMSenDVT-NnTm61Lzfl6xzmSep1CJCvzKALHboTa6-U1hRcN-rgFuKKWsY_bdnlnUc5R2L-KQ9vDU0GM6BunBcEuM1JRYR4DT7cuQFDCnMwFkmmLKR47Yts4=w100-h134-n-k-no")),
                Purchasable(title: "Notre-Dame de Paris", subTitle: "$100", imageURL: URL(string: "https://lh5.googleusercontent.com/proxy/PBqoR7CECC75ifTaFHkzjOyP_im_PJ2Cn5HvOZOC5sln7AOaE1oxitPBSTWKHADCb0dygp6FNg8t1-V3ALlpl_ympwrn7AayOcsAmMCscknnN1xs1g1EgGYkfsJ6CIrtIAHrjTDLmNDpL0mGqNdQ7vzZqRQ=w100-h134-n-k-no")),
                Purchasable(title: "Arc de Triomphe", subTitle: "$25", imageURL: URL(string: "https://lh6.googleusercontent.com/proxy/mTzWUDX55OMJoer0YUH0Vfviz9p8chgFMz3LJJ7Y9BBfC3m_ve0lYTGpvKzmTrVDVlPgw1iK2dSp_EeMzekD50Z5SwSrYQntco00gyXFaGM9RbP1TtA53SkTctBstcJ7a5VMLxM1uEiEdEwLqiQ3E5j66fc=w100-h134-n-k-no"))
                ]),
            PurchasableGroup(isFeatured: false, title: "London", purchasables: [
                Purchasable(title: "Big Ben", subTitle: "$50", imageURL: URL(string: "https://lh3.googleusercontent.com/proxy/yNFQVlYTok_fIB8M5EgZMwOYKVyA1BrePp3DEeQB8gOYGqRno_7bkjWbrZyt-FrPAPYAhVZKMNk81Cg1G7aREDrLXSYeCOi9B4yOeLnaOd5-ujfBOUmGlb4VC3u2L-d0mKDPj-jYvKFRQLULbY31IbpXYtE=w100-h134-n-k-no")),
                Purchasable(title: "London Eye", subTitle: "$130", imageURL: URL(string: "https://lh5.googleusercontent.com/proxy/oQDcIK54obbfb7g16v5hNuFk1t9wugKNR55W6r1pUCnketzk0Pk9y6GzDvtDhbkgMNvEKy4qAwcBHpzqrnKg3jGbBpWlq2vs8u9SOSO6CkSQJhRF-8arMdPiQUptn0vaELoSj0OghUAO4mANv_kWpH-X_sU=w100-h134-n-k-no")),
                Purchasable(title: "Tower of London", subTitle: "$100", imageURL: URL(string: "https://lh5.googleusercontent.com/proxy/Aevf3KDgO9XF48cATifyhVgtYLHSmpWfcNew6FN_elg9tx5SSzqn10jSsJQAenqzX9Uy4bT_U--BW1MIb3MJAsVqK73EKL8kk7M81Dm3r_Q__06jmubExJV-5Mpi-MGcijc0L895C5_Zd-hLl4Ryc5-f00U=w100-h134-n-k-no")),
                Purchasable(title: "Buckingham Palace", subTitle: "$25", imageURL: URL(string: "https://lh3.googleusercontent.com/proxy/c4bPFALfSTj8gN1g5J1QE02Poz0KYC2KVNbNk03KbOoR0usJK-xICr_gAx2_MCXBCHRfqatGsMQWv6rt4Aa1cjbD2cf3ZZ_CbKd2-ctLUQ7ZqJ9KseQ0N_mb-Hw8EIcEFzqh73n7DUIEbuwkvXK1cAf1Ur_T1kZmFcA=w100-h134-n-k-no"))
                ]),
            PurchasableGroup(isFeatured: false, title: "New York City", purchasables: [
                Purchasable(title: "Statue of Liberty", subTitle: "$40", imageURL: URL(string: "https://lh3.googleusercontent.com/proxy/D4_nAYgXBpJVd-qCUCQ0YW_60Xc5SY9NtbRxzHThrMT0EtzFVoyNfM01uXG95Fyc3trD5TIn3yNFV6cceESKAO3366AUhBcXWPZXy_EJlqnyF5d_19SiVK1ci7_Tz01hOXHlmnsO2wRtDMXov9j1k7E7AV0=w100-h134-n-k-no")),
                Purchasable(title: "Central Park", subTitle: "FREE", imageURL: URL(string: "https://lh5.googleusercontent.com/proxy/tptwx1ScsETKYwBy2Eos1jCLKGqdT3Omg3VhvV_kp-JVRCvx8vA6Q_u5_chlCjCUM81Vlpbbb-1IfLq9AyaNTGjSScsPI8mGhk3ISEewiS8WFCkfI_TS7T0CFWSbIKNRaKYrprQ1wZLDKYm7voDTzW26pSg=w100-h134-n-k-no")),
                Purchasable(title: "Empire State Building", subTitle: "$100", imageURL: URL(string: "https://lh5.googleusercontent.com/proxy/vMnfweGGJ2R3UeOc3c4G9RgCEViKONi9b9S19fwbSDNHbvJ-Jf83Yu5eFNI4XPi_NRGsNy_74Foo_BLSZ7HAhUFTIrqn81TJoA95v2jn7Ib7A_IlvSS6RoLvypx_1sjdB4Mr_ceAvpi2ZYQLdjIQHwWQm8M=w100-h134-n-k-no")),
                Purchasable(title: "Times Square", subTitle: "FREE", imageURL: URL(string: "https://lh3.googleusercontent.com/proxy/xEvWT1wmIiPRtokwx6A4N5696Ry52hXtNuwnYDDv5AOEKcc_M7K8IeHsLvdjWR4Xh0dMu3rlfbBeLodZPS9wWeAxS6DOO-eTwXSRj8E0M-mk0mcfQu8gau6PyNHt7wZLCgKhgET7VaUoMlYM-FDd8VXNLgg=w100-h134-n-k-no"))
                ])
        ]

        let vc = UINib(nibName: "PurchasableGroupsViewController", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PurchasableGroupsViewController
        vc.groups = groups

        present(vc, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPressAuth(_ sender: UIBarButtonItem) {
        PassengerKit.clearStoredCredentials()
    }

}

