import PropTypes from 'prop-types'
import '../style/Header.css'
const Header = ({title}) => {
      return (
          <h1 className="Header">
              <div>{title}</div>
          </h1>
      )
  }
  
  Header.defaultProps = {
      title: "MCPS MVP",
  }

  Header.propTypes = {
      title: PropTypes.string.isRequired,
  }
  
  export default Header
  