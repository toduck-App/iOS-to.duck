brew tap tuist/tuist
echo "brew tap tuist/tuist.."
brew install tuist@4.18.0
echo "installed Tuist.."

cd ..
echo ".."
tuist clean
echo "cleaned"
tuist install
echo "installed Tuist"
tuist generate
echo "generated Tuist"
