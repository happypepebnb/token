# Happy Pepe BNB

## Tokenomics

**Maximum supply:** 1,000,000,000,000,000 HPY  
**Initial Supply:** 750,000,000,000,000 HPY  
**Initial Burn:** 250,000,000,000,000 HPY (v1)  
**Airdrops:** 50,000,000,000,000 HPY (v1)
**Buy fee:** 3% + 2% Burn fee  
**Sell fee:** 3% + 2% Burn fee  
**Bonus fee:** 3% (on Bonus win)  
**Initial Liquidity:** 95% locked for 6 months (was on v1)
**Ownership:** Renounced  
**Min. eligible holders:** 20  
**Min. bonus percent:** 1%  
**Max. bonus percent:** 20%  
**Max. possible bonus:** 0.1% Max. supply

### Abount Bonus

In principle bonus works like this:  

1. Contract checks how many tokens are available for bonuses (max. supply - total supply)
2. A random holder is selected
3. Pick a number between 0 - 9 (set to 1 in 6 on v2 and will not change)
4. If picked number is 3 (was 5) holder gets a bonus
5. Pick a number between 1 - 20 to be bonus percent
6. Check how many eligible tokens holder owns divide by 100 and multiply by bonus percent

To be eligible for a bonus, holders of HPYPEPE tokens must meet a minimum threshold of 100,000,000 tokens. This requirement ensures that only committed token holders can participate in the bonus program. It's important to note that the bonus is exclusively available to addresses that have directly purchased the tokens and not to those who have acquired them through transfers. This ensures that the bonus rewards go to those who have actively invested in the project.

To maintain transparency and accurate record-keeping, the contract incorporates a separate ledger specifically dedicated to tracking token transactions. Whenever tokens are sold or transferred, they are deducted from the accounting account, ensuring a precise calculation of eligible funds for the bonus. As a convenience, holders can connect their wallets to our website, granting them access to view the specific funds that contribute towards the bonus calculation.

During the sale process, the system periodically selects a random token holder every 100 blocks but only if at least 100.000.000 HPYPEPE were sold. If the 100 block mark was missed, the bonus will happen on the first sale after that but it must meet the minimum threshold.

To determine if the selected holder will receive a bonus, a random number between 0 and 9 is generated. If the chosen number happens to be 5, the selected holder will be rewarded with a bonus. This approach adds an element of unpredictability to the bonus distribution, enhancing the overall user experience.

The missed bonuses and addresses are listed on our website. Currently, only the last 10 bonus rounds are displayed but we will expand that so all will be listed.

The percentage of the bonus is determined by another random number generated between 1 and 20. This percentage represents the additional tokens that a bonus recipient will receive based on their holdings in a bookkeeping account. The minimum bonus percentage is set at 1%. The maximum bonus percentage can reach up to 20%.

The bonus program offers an exciting opportunity for token holders to earn additional tokens. The maximum possible amount that can be won as a bonus is set at 0.1% of the maximum token supply, equivalent to 1,000,000,000 HPYPEPE tokens. This generous upper limit ensures that the potential rewards are significant for those fortunate enough to receive the bonus.

It is worth noting that all token holders are eligible to receive the bonus multiple times. This means that even if a holder has already received a bonus, they remain eligible for future bonus distributions. This inclusivity encourages ongoing participation and engagement from the token holders, promoting a sense of long-term commitment and loyalty to the project.

The token-burning mechanism plays a vital role in the overall tokenomics of the project. During each buy and sell transaction, 2% of the purchased or sold amount is burned and that has a direct effect on how many tokens are available for bonuses.

The availability of tokens for bonus rewards is determined by the difference between the maximum token supply and the current token supply, accounting for the burned tokens.

When a token holder receives a bonus, the additional tokens won are minted directly into their wallet. There is a 3% fee on the bonus amount as a means to sustain the project's operations and ongoing development. This fee ensures that a portion of the bonus rewards contributes to the project's sustainability and growth.

Our website provides a comprehensive overview of the bonus program, offering users valuable insights and information. Website data is updated using push notifications.

We have released our PlayToEarn game alpha version.
More about the game at pepenomicon.com
to play alpha go to pepenomicon.net/alpha
