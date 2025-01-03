/**
 * Authorization middleware
 *
 * @param   {String}   role   Role for protected route
 * @returns {void}
 */
// ex: 'user:list'
export default (role) => async (ctx, next) => {
  const { roles } = ctx.state;
  const allowed = roles.includes(role);
  if (allowed) {
    await next();
    return;
  }
  ctx.status = 403;
};
