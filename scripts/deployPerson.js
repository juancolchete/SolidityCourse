const hre = require("hardhat");

async function main() {
    const PersonManange = await hre.ethers.getContractFactory("PersonManange");
    const personManange = await PersonManange.deploy();
    await personManange.deployed();
    const InteractPerson = await hre.ethers.getContractFactory("InteractPerson");
    const interactPerson = await InteractPerson.deploy(personManange.address);
    await interactPerson.deployed();
    console.log("Deployed address:");
    console.log("Person Manange: "+personManange.address);
    console.log("Interact Person: "+interactPerson.address);
    let PERSON_ADM = await personManange.PERSON_ADM();
    console.log(PERSON_ADM)
    await personManange.grantRole(PERSON_ADM,interactPerson.address);
    await interactPerson.addPersonInteract(true, "Juan", "30");
    let person = await interactPerson.getPersonInteract(0);
    console.log(person);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });