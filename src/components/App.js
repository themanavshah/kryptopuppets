import React, {Component} from "react";
import { MDBCard, MDBCardBody, MDBCardTitle, MDBCardText, MDBCardImage, MDBBtn } from "mdb-react-ui-kit";

import kryptoPuppets from '../ethereum/kpups';
import web3 from "../ethereum/web3";
import './App.css'

class App extends Component {

    constructor(props) {
        super(props);
        this.state = {
            name: '',
            address: '',
            totalSupply: 0,
            kryptoPuppetsList: [],
            puppetName: ''
        }
    }

    async componentDidMount() {
        await this.loadContract();
    }

    async loadContract() {
        var name  = await kryptoPuppets.methods.name().call();
        const address = await web3.eth.getAccounts();
        var kryptoPupz = await kryptoPuppets.methods.getKPUPList().call();

        this.setState({
            name, 
            address: address[0], 
            totalSupply: kryptoPupz.length, 
            kryptoPuppetsList: kryptoPupz
        });
    }

    mint = async (kryptoPuppet) => {
        await kryptoPuppets.methods.mint(kryptoPuppet).send({from: this.state.address}).once('receipt', (receipt) => {
            this.setState({
                kryptoPuppets: [...this.state.kryptoPuppetsList, kryptoPuppet],
                totalSupply: this.state.totalSupply + 1,
            })
        })
    }

    // async loadBlockchainData() {
    //     var networkId = web3.eth.net.getId();
    //     var networkData = 
    // }

    assignValue(event) {
        event.preventDefault();
        this.setState({puppetName: event.value.text});
    }

    render() {
        console.log("totalSupply", this.state.totalSupply);
        console.log(this.state.kryptoPuppetsList);
        return (
            <div className="container-filled">
                <nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
                    <div className="navbar-brand col-sm-3 col-md-3 mr-0" style={{color: 'white'}}>
                        Krypto Puppet NFTs    
                    </div>
                    <ul className="navbar-nav px-3">
                        <li className="nav-item text-nowrap d-none d-sm-none d-sm-block">
                            <small className="text-white">
                                {this.state.address}
                            </small>
                        </li>
                    </ul>
                </nav>

                <div className="contain-fluid mt-1">
                    <div className="row">
                        <main role="main" className="col-lg-12 d-flex text-center">
                            <div className="content mr-auto ml-auto" style={{opacity: "0.8"}}>
                                <h1 style={{color: "black"}}>kryptoPuppetz NFT marketplace</h1>
                                <form onSubmit={(event) => {
                                    event.preventDefault();
                                    const puppetName = this.puppetName.value
                                    this.mint(puppetName);
                                }}>
                                    <input 
                                        type='text' 
                                        placeholder="Add a file location" 
                                        className="form-control mb-1"  
                                        ref={(input)=>this.puppetName = input}
                                    />
                                    <input 
                                    style={{margin: "6px"}}
                                        type='submit' 
                                        value="MINT" 
                                        className="btn btn-primary btn-black"  
                                    />
                                </form>
                            </div>
                        </main>
                    </div>
                    <hr></hr>
                    <div className="row textCenter">
                        {this.state.kryptoPuppetsList.map((kpup, key) => {
                            return (
                                <div>
                                    <div>
                                        <MDBCard className="token img" style={{maxWidth: "22rem"}}>
                                            <MDBCardImage src = {kpup} position="top" height='250rem' style={{margin: '4px'}} />
                                            <MDBCardBody src={kpup} position='top' style={{marginRight: '4px'}} />
                                            <MDBCardBody>
                                                <MDBCardTitle>
                                                    {kpup}
                                                </MDBCardTitle>
                                                <MDBCardText>
                                                    The krypto puppets are 7 uniquely generated rare live bird puppet from planet of cyberglobe skunk galaxy of saga. There is only puppet of each kind which can be minted on ethereum network.
                                                </MDBCardText>
                                                <MDBBtn href={kpup}>Download</MDBBtn>
                                            </MDBCardBody>
                                        </MDBCard>
                                    </div>
                                </div>
                            )
                        })}
                    </div>
                </div>
            </div>
        );
    }
}

export default App;